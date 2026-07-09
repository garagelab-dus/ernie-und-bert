#!/usr/bin/env zsh

set -euo pipefail

debug="false"
verbosity="false"
robot=""

usage() {
	cat <<'EOF'
Usage: run_a_movement_loop.sh [options]

Options:
	-d, --debug true|false      Print first 20 target positions without moving motors.
	-v, --verbosity true|false  Print per-iteration current motor positions.
	-r, --robot ernie|bert      Select target robot.
	-h, --help                  Show this help message.
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		-d|--debug)
			[[ $# -ge 2 ]] || { echo "Error: $1 requires true|false" >&2; exit 1; }
			debug="$2"
			shift 2
			;;
		-v|--verbosity)
			[[ $# -ge 2 ]] || { echo "Error: $1 requires true|false" >&2; exit 1; }
			verbosity="$2"
			shift 2
			;;
		-r|--robot)
			[[ $# -ge 2 ]] || { echo "Error: $1 requires ernie|bert" >&2; exit 1; }
			robot="$2"
			shift 2
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			echo "Error: Unknown argument: $1" >&2
			usage
			exit 1
			;;
	esac
done

if [[ "$debug" != "true" && "$debug" != "false" ]]; then
	echo "Error: --debug must be true or false" >&2
	exit 1
fi

if [[ "$verbosity" != "true" && "$verbosity" != "false" ]]; then
	echo "Error: --verbosity must be true or false" >&2
	exit 1
fi

if [[ "$robot" != "ernie" && "$robot" != "bert" ]]; then
	echo "Error: --robot must be ernie or bert" >&2
	usage
	exit 1
fi

if [[ "$robot" == "ernie" ]]; then
	robot_type="${ernie_type:-}"
	robot_port="${ernie_port:-}"
	robot_id="${ernie_id:-}"
	supported_types="so100_follower,so101_follower"
else
	robot_type="${bert_type:-}"
	robot_port="${bert_port:-}"
	robot_id="${bert_id:-}"
	supported_types="so100_leader,so101_leader"
fi

if [[ -z "$robot_type" ]]; then
	echo "Error: type variable for '$robot' is not set" >&2
	exit 1
fi
if [[ -z "$robot_port" ]]; then
	echo "Error: port variable for '$robot' is not set" >&2
	exit 1
fi
if [[ -z "$robot_id" ]]; then
	echo "Error: id variable for '$robot' is not set" >&2
	exit 1
fi

if ! command -v python >/dev/null 2>&1; then
	echo "Error: python is not installed or not in PATH" >&2
	exit 1
fi

echo "robot: $robot"
echo "type: $robot_type"
echo "port: $robot_port"
echo "id: $robot_id"
echo "debug: $debug"
echo "verbosity: $verbosity"

printf "Continue? ([Y]/n) "
read -r reply
if [[ -n "$reply" && ! "$reply" =~ ^[Yy]$ ]]; then
	echo "Aborting."
	exit 1
fi

DEBUG="$debug" \
VERBOSITY="$verbosity" \
ROBOT_NAME="$robot" \
ROBOT_TYPE="$robot_type" \
ROBOT_PORT="$robot_port" \
ROBOT_ID="$robot_id" \
SUPPORTED_TYPES="$supported_types" \
ITERATIONS="10000" \
python - <<'PY'
import os
import select
import sys
import time
from contextlib import contextmanager

import termios
import tty

from lerobot.teleoperators.so_leader.config_so_leader import SOLeaderTeleopConfig
from lerobot.teleoperators.so_leader.so_leader import SOLeader


def parse_supported_types(raw):
	return {item.strip() for item in raw.split(",") if item.strip()}


@contextmanager
def cbreak_mode(input_stream):
	if input_stream is None:
		yield
		return
	fd = input_stream.fileno()
	old_settings = termios.tcgetattr(fd)
	try:
		tty.setcbreak(fd)
		yield
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def q_pressed(input_stream):
	if input_stream is None:
		return False
	ready, _, _ = select.select([input_stream], [], [], 0)
	if not ready:
		return False
	ch = input_stream.read(1)
	return ch.lower() == "q"


def triangular_ratio(iteration_idx, total_iterations):
	if total_iterations <= 1:
		return 0.0
	phase = iteration_idx / float(total_iterations - 1)
	return 1.0 - abs((2.0 * phase) - 1.0)


def loop_ratio(iteration_idx, total_iterations):
	if total_iterations <= 1:
		return 0.5
	phase = iteration_idx / float(total_iterations - 1)
	if phase < 0.25:
		return 0.5 + (phase / 0.25) * 0.5
	if phase < 0.5:
		return 1.0 - ((phase - 0.25) / 0.25) * 0.5
	if phase < 0.75:
		return 0.5 - ((phase - 0.5) / 0.25) * 0.5
	return (phase - 0.75) / 0.25 * 0.5


def interpolate_positions(start_positions, target_positions, ratio):
	goals = {}
	for motor_name, start in start_positions.items():
		target = target_positions[motor_name]
		goals[motor_name] = int(round(start + (target - start) * ratio))
	return goals


def compute_loop_positions(min_positions, max_positions, ratio):
	goals = {}
	for motor_name, min_pos in min_positions.items():
		max_pos = max_positions[motor_name]
		goals[motor_name] = int(round(min_pos + (max_pos - min_pos) * ratio))
	return goals


def ramp_to_target(bus, start_positions, target_positions, steps, settle_s, input_stream):
	for step in range(1, steps + 1):
		if q_pressed(input_stream):
			return False
		ratio = step / float(steps)
		goals = interpolate_positions(start_positions, target_positions, ratio)
		bus.sync_write("Goal_Position", goals, normalize=False)
		time.sleep(settle_s)
	return True


def read_positions(bus, motor_names):
	return {
		motor_name: int(bus.read("Present_Position", motor_name, normalize=False))
		for motor_name in motor_names
	}


def read_limits(bus, motor_names):
	min_positions = {
		motor_name: int(bus.read("Min_Position_Limit", motor_name, normalize=False))
		for motor_name in motor_names
	}
	max_positions = {
		motor_name: int(bus.read("Max_Position_Limit", motor_name, normalize=False))
		for motor_name in motor_names
	}
	return min_positions, max_positions


def capture_accel_limits(bus, motor_names):
	accel_limits = {}
	for motor_name in motor_names:
		try:
			accel_limits[motor_name] = int(bus.read("Maximum_Acceleration", motor_name, normalize=False))
		except Exception:
			accel_limits[motor_name] = 254
	return accel_limits


def main():
	robot_name = os.environ["ROBOT_NAME"]
	robot_type = os.environ["ROBOT_TYPE"]
	robot_port = os.environ["ROBOT_PORT"]
	robot_id = os.environ["ROBOT_ID"]
	supported_types = parse_supported_types(os.environ["SUPPORTED_TYPES"])
	debug_enabled = os.environ.get("DEBUG", "false").lower() == "true"
	verbose_enabled = os.environ.get("VERBOSITY", "false").lower() == "true"
	total_iterations = int(os.environ.get("ITERATIONS", "10000"))

	if robot_type not in supported_types:
		print(
			f"Error: unsupported type '{robot_type}' for robot '{robot_name}'. "
			f"Expected one of {sorted(supported_types)}",
			file=sys.stderr,
		)
		return 1

	teleop = SOLeader(SOLeaderTeleopConfig(port=robot_port, id=robot_id))
	bus = None
	torque_enabled = False

	try:
		teleop.connect(calibrate=False)
		bus = teleop.bus
		motor_names = list(bus.motors)
		if not motor_names:
			print("No motors found on bus.", file=sys.stderr)
			return 1

		start_positions = read_positions(bus, motor_names)
		min_positions, max_positions = read_limits(bus, motor_names)
		mid_positions = {
			motor_name: (min_positions[motor_name] + max_positions[motor_name]) // 2
			for motor_name in motor_names
		}
		accel_limits = capture_accel_limits(bus, motor_names)

		if debug_enabled:
			print("Debug mode enabled: first 20 loop targets (no motor movement).")
			print(f"actual_start_positions={start_positions}")
			preview_count = min(20, total_iterations)
			for idx in range(preview_count):
				ratio = loop_ratio(idx, total_iterations)
				goals = compute_loop_positions(min_positions, max_positions, ratio)
				print(f"iter={idx:05d} goals={goals}")
			return 0

		bus.enable_torque(motors=motor_names)
		torque_enabled = True

		input_stream = sys.stdin if sys.stdin.isatty() else None
		print("Initial movement: current positions -> middle positions.")
		with cbreak_mode(input_stream):
			if not ramp_to_target(bus, start_positions, mid_positions, steps=100, settle_s=0.02, input_stream=input_stream):
				print("Q detected during initial movement.")
			else:
				print("Starting loop movement (press Q to stop).")
				for idx in range(total_iterations):
					if q_pressed(input_stream):
						print("Q detected. Stopping loop.")
						break

					accel_ratio = triangular_ratio(idx, total_iterations)
					accel_factor = 0.1 + 0.9 * accel_ratio
					loop_pos_ratio = loop_ratio(idx, total_iterations)

					goals = compute_loop_positions(min_positions, max_positions, loop_pos_ratio)

					for motor_name in motor_names:
						max_accel = max(1, accel_limits[motor_name])
						accel_value = max(1, int(round(max_accel * accel_factor)))
						try:
							bus.write("Maximum_Acceleration", motor_name, accel_value, normalize=False)
						except Exception:
							pass
						bus.write("Acceleration", motor_name, accel_value, normalize=False)

					bus.sync_write("Goal_Position", goals, normalize=False)

					if verbose_enabled:
						now_positions = read_positions(bus, motor_names)
						print(f"iter={idx:05d} accel_factor={accel_factor:.3f} pos={now_positions}")

					time.sleep(0.01)

			print("Returning to start positions.")
			current_positions = read_positions(bus, motor_names)
			ramp_to_target(bus, current_positions, start_positions, steps=120, settle_s=0.02, input_stream=None)
			print("Movement loop finished.")

		return 0
	except KeyboardInterrupt:
		print("\nInterrupted by user.")
		return 130
	except Exception as exc:
		print(f"Error during movement loop: {exc}", file=sys.stderr)
		return 1
	finally:
		try:
			if bus is not None and torque_enabled:
				bus.disable_torque(motors=list(bus.motors))
		except Exception:
			pass
		try:
			teleop.disconnect()
		except Exception:
			pass


raise SystemExit(main())
PY
