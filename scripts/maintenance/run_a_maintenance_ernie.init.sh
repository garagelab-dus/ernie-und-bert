#!/usr/bin/env zsh

# This script is for maintenance purposes to read motor data from ERNIE 
# (a lerobot SO-101 **FOLLOWER** arm) in case of issues.
# It connects to the ERNIE, reads various registers from all motors, and displays them in a table. 
# It also has an optional "check after reassembly" mode 
# to move motors back to their original positions after maintenance.
#
# if you want to maintenance BERT, use run_a_maintenance_ernie.init.sh instead.

debug="false"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      if [[ -z "$2" ]]; then
        echo "Error: --debug requires a value (true|false)"
        exit 1
      fi
      debug="$2"
      shift 2
      ;;
    *)
      echo "Error: Unknown argument: $1"
      echo "Usage: $0 [--debug true|false]"
      exit 1
      ;;
  esac
done


echo "ATTENTION - script under development"
echo "Switch to BERT controller board"

exit 1

if [[ "$debug" != "true" && "$debug" != "false" ]]; then
  echo "Error: --debug must be true or false"
  exit 1
fi

# check if the following variables are set: ernie_type, ernie_port, ernie_id
if [[ -z "$ernie_type" ]]; then
  echo "Error: ernie_type is not set. Please set it to the type of ERNIE (e.g., 'SO-101')."
  exit 1
fi
if [[ -z "$ernie_port" ]]; then
  echo "Error: ernie_port is not set. Please set it to the serial port of ERNIE (e.g., '/dev/ttyUSB0')."
  exit 1
fi
if [[ -z "$ernie_id" ]]; then
  echo "Error: ernie_id is not set. Please set it to the ID of ERNIE (e.g., '1')."
  exit 1
fi

# print the variables
echo "ernie_type: $ernie_type"
echo "ernie_port: $ernie_port"
echo "ernie_id: $ernie_id"
echo "debug: $debug"

# ask for verification (default to yes)
printf "Are these values correct? ([Y]/n) "
read -r reply
if [[ -n "$reply" && ! "$reply" =~ ^[Yy]$ ]]; then
  echo "Aborting."
  exit 1
fi

# we are in maintenance mode. the is no lerobot code for this.
# we want to read all motors and write their data to the screen.

if ! command -v python >/dev/null 2>&1; then
  echo "Error: python is not installed or not in PATH"
  exit 1
fi

DEBUG="$debug" python - <<'PY'
import os
import re
import select
import sys
import time
import traceback
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path

import termios
import tty

from lerobot.teleoperators.so_leader.config_so_leader import SOLeaderTeleopConfig
from lerobot.teleoperators.so_leader.so_leader import SOLeader

try:
  from rich.console import Console
  from rich.live import Live
  from rich.table import Table
except ImportError:
  Console = None
  Live = None
  Table = None


ernie_type = os.environ["ernie_type"]
ernie_port = os.environ["ernie_port"]
ernie_id = os.environ["ernie_id"]

EXPECTED_MOTOR_NAMES = (
  "shoulder_pan",
  "shoulder_lift",
  "elbow_flex",
  "wrist_flex",
  "wrist_roll",
  "gripper",
)
EXPECTED_MOTOR_IDS = {
  "shoulder_pan": 1,
  "shoulder_lift": 2,
  "elbow_flex": 3,
  "wrist_flex": 4,
  "wrist_roll": 5,
  "gripper": 6,
}

supported_types = {"so100_leader", "so101_leader"}
if ernie_type not in supported_types:
  print(
    f"Error: maintenance motor read currently supports {sorted(supported_types)} only; got '{ernie_type}'",
    file=sys.stderr,
  )
  sys.exit(1)

teleop = SOLeader(SOLeaderTeleopConfig(port=ernie_port, id=ernie_id))
debug_enabled = os.environ.get("DEBUG", "false").lower() == "true"
log_path = None


def init_debug_log():
  timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
  logs_dir = Path("maintenance") / "logs"
  logs_dir.mkdir(parents=True, exist_ok=True)
  return logs_dir / f"maintenance_{ernie_id}_{timestamp}.log"


if debug_enabled:
  log_path = init_debug_log()
  with log_path.open("a", encoding="utf-8") as f:
    f.write(f"[{datetime.now().isoformat()}] DEBUG enabled for {ernie_id} on {ernie_port}\n")
  print(f"Debug logging enabled: {log_path}")


def log_debug_error(motor_name, data_name, exc):
  if not debug_enabled or log_path is None:
    return
  with log_path.open("a", encoding="utf-8") as f:
    f.write(
      f"[{datetime.now().isoformat()}] motor={motor_name} register={data_name} "
      f"error={type(exc).__name__}: {exc}\n"
    )


def safe_read(bus, data_name, motor_name):
  try:
    return bus.read(data_name, motor_name, normalize=False)
  except Exception as exc:
    # Keep maintenance output alive even when one motor/register read fails.
    log_debug_error(motor_name, data_name, exc)
    return f"ERR:{type(exc).__name__}"


def parse_missing_motor_ids(exc):
  text = str(exc)
  match = re.search(r"Missing motor IDs:\n(?P<section>(?:\s+-\s+\d+.*\n)+)", text)
  if match is None:
    return set()
  return {
    int(found_id)
    for found_id in re.findall(r"^\s+-\s+(\d+)\b", match.group("section"), flags=re.MULTILINE)
  }


def collect_rows(bus, unresponsive_motor_names=None):
  unresponsive_motor_names = set(unresponsive_motor_names or ())
  rows = []
  for motor_name in EXPECTED_MOTOR_NAMES:
    motor = bus.motors.get(motor_name)
    motor_id = motor.id if motor is not None else EXPECTED_MOTOR_IDS[motor_name]
    motor_unresponsive = motor_name in unresponsive_motor_names or motor is None
    if motor is None:
      rows.append(
        {
          "motor": motor_name,
          "id": motor_id,
          "responding": False,
          "position_raw": "MISSING",
          "load_raw": "MISSING",
          "current_raw": "MISSING",
          "torque_limit_raw": "MISSING",
          "max_torque_limit_raw": "MISSING",
          "voltage_raw": "MISSING",
          "temperature_c": "MISSING",
        }
      )
      continue

    position_raw = safe_read(bus, "Present_Position", motor_name)
    load_raw = safe_read(bus, "Present_Load", motor_name)
    current_raw = safe_read(bus, "Present_Current", motor_name)
    torque_limit_raw = safe_read(bus, "Torque_Limit", motor_name)
    max_torque_limit_raw = safe_read(bus, "Max_Torque_Limit", motor_name)
    voltage_raw = safe_read(bus, "Present_Voltage", motor_name)
    temperature_c = safe_read(bus, "Present_Temperature", motor_name)
    responding = not motor_unresponsive and not any(
      isinstance(value, str) and value.startswith("ERR:")
      for value in (
        position_raw,
        load_raw,
        current_raw,
        torque_limit_raw,
        max_torque_limit_raw,
        voltage_raw,
        temperature_c,
      )
    )
    rows.append(
      {
        "motor": motor_name,
        "id": motor_id,
        "responding": responding,
        "position_raw": position_raw,
        "load_raw": load_raw,
        "current_raw": current_raw,
        "torque_limit_raw": torque_limit_raw,
        "max_torque_limit_raw": max_torque_limit_raw,
        "voltage_raw": voltage_raw,
        "temperature_c": temperature_c,
      }
    )
  return rows


def snapshot_positions(rows):
  return {
    row["motor"]: row["position_raw"]
    for row in rows
    if row.get("responding") and not (isinstance(row["position_raw"], str) and row["position_raw"].startswith("ERR:"))
  }


def make_rich_table(rows, title, target_positions=None):
  table = Table(title=title)
  columns = [
    "motor",
    "id",
    "status",
    "position_raw",
    "load_raw",
    "current_raw",
    "torque_limit_raw",
    "max_torque_limit_raw",
    "voltage_raw",
    "temperature_c",
  ]
  if target_positions is not None:
    columns.insert(4, "target_raw")
  for col in columns:
    table.add_column(col)
  for r in rows:
    status = "responding" if r.get("responding") else "not responding"
    values = [
      str(r["motor"]),
      str(r["id"]),
      status,
      str(r["position_raw"]),
      str(r["load_raw"]),
      str(r["current_raw"]),
      str(r["torque_limit_raw"]),
      str(r["max_torque_limit_raw"]),
      str(r["voltage_raw"]),
      str(r["temperature_c"]),
    ]
    if target_positions is not None:
      values.insert(4, str(target_positions.get(r["motor"], "-")))
    table.add_row(*values, style="red" if not r.get("responding") else None)
  return table


def print_plain_table(rows, title=None, target_positions=None):
  cols = [
    "motor",
    "id",
    "status",
    "position_raw",
    "load_raw",
    "current_raw",
    "torque_limit_raw",
    "max_torque_limit_raw",
    "voltage_raw",
    "temperature_c",
  ]
  if target_positions is not None:
    cols.insert(4, "target_raw")
  if title:
    print(title)
  widths = {c: max(len(c), *(len(str(r[c])) for r in rows)) for c in cols}
  if target_positions is not None:
    widths["target_raw"] = max(
      len("target_raw"),
      *(len(str(target_positions.get(r["motor"], "-"))) for r in rows),
    )
  header = " | ".join(c.ljust(widths[c]) for c in cols)
  sep = "-+-".join("-" * widths[c] for c in cols)
  print(header)
  print(sep)
  for r in rows:
    status = "responding" if r.get("responding") else "not responding"
    motor_display = r["motor"] if r.get("responding") else f"\033[1;31m{r['motor']}\033[0m"
    status_display = status if r.get("responding") else f"\033[1;31m{status}\033[0m"
    values = {
      **r,
      "motor": motor_display,
      "status": status_display,
      "target_raw": target_positions.get(r["motor"], "-") if target_positions is not None else "-",
    }
    print(" | ".join(str(values[c]).ljust(widths[c]) for c in cols))


@contextmanager
def cbreak_mode(input_stream):
  if input_stream is None:
    yield
    return
  fd = input_stream.fileno()
  old = termios.tcgetattr(fd)
  try:
    tty.setcbreak(fd)
    yield
  finally:
    termios.tcsetattr(fd, termios.TCSADRAIN, old)


def q_pressed(input_stream):
  if input_stream is None:
    return False
  ready, _, _ = select.select([input_stream], [], [], 0)
  if not ready:
    return False
  ch = input_stream.read(1)
  return ch.lower() == "q"


def ask_yes_no_default_yes(prompt, input_stream):
  if input_stream is not None:
    print(prompt, end="", flush=True)
    reply = input_stream.readline()
    if reply == "":
      return True
    reply = reply.strip()
  else:
    reply = input(prompt).strip()
  return reply == "" or reply.lower() == "y"


def print_bold_red(message):
  if Console is not None:
    Console(stderr=True).print(f"[bold red]{message}[/bold red]")
  else:
    print(f"\033[1;31m{message}\033[0m", file=sys.stderr)


def is_power_connection_error(exc):
  text = str(exc)
  markers = (
    "Missing motor IDs:",
    "There is no status packet!",
    "Could not connect on port",
    "motor check failed on port",
  )
  return any(marker in text for marker in markers)


def write_exception_log(exc, label, log_file_path=None):
  if log_file_path is None:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    logs_dir = Path("maintenance") / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)
    log_file_path = logs_dir / f"maintenance_error_{ernie_id}_{timestamp}.log"

  with log_file_path.open("a", encoding="utf-8") as f:
    f.write(f"[{datetime.now().isoformat()}] {label}\n")
    f.write("".join(traceback.format_exception(type(exc), exc, exc.__traceback__)))
    f.write("\n")

  return log_file_path


def capture_motion_settings(bus, motor_names=None):
  if motor_names is None:
    motor_names = bus.motors
  settings = {}
  for motor_name in motor_names:
    motor_settings = {
      "Acceleration": bus.read("Acceleration", motor_name, normalize=False),
    }
    if getattr(bus, "protocol_version", None) == 0:
      motor_settings["Maximum_Acceleration"] = bus.read("Maximum_Acceleration", motor_name, normalize=False)
    settings[motor_name] = motor_settings
  return settings


def set_minimum_acceleration(bus, motor_names=None):
  saved_settings = capture_motion_settings(bus, motor_names)
  for motor_name, motor_settings in saved_settings.items():
    if "Maximum_Acceleration" in motor_settings:
      bus.write("Maximum_Acceleration", motor_name, 1, normalize=False)
    bus.write("Acceleration", motor_name, 1, normalize=False)
  return saved_settings


def restore_motion_settings(bus, settings):
  for motor_name, motor_settings in settings.items():
    if "Maximum_Acceleration" in motor_settings:
      bus.write("Maximum_Acceleration", motor_name, motor_settings["Maximum_Acceleration"], normalize=False)
    bus.write("Acceleration", motor_name, motor_settings["Acceleration"], normalize=False)


def capture_torque_limits(bus, motor_names=None):
  if motor_names is None:
    motor_names = bus.motors
  return {
    motor_name: int(bus.read("Torque_Limit", motor_name, normalize=False))
    for motor_name in motor_names
  }


def soft_release_torque(bus, torque_limits, input_stream=None):
  if not torque_limits:
    return

  currents = {}
  for motor_name in bus.motors:
    try:
      currents[motor_name] = abs(int(bus.read("Present_Current", motor_name, normalize=False)))
    except Exception:
      pass

  if not currents:
    return

  motor_to_release = max(currents, key=currents.get)
  original_torque_limit = int(torque_limits.get(motor_to_release, 0))
  if original_torque_limit <= 0:
    return

  max_steps = min(original_torque_limit, 300)
  current_torque_limit = original_torque_limit
  print(
    f"Soft release on '{motor_to_release}' (id={bus.motors[motor_to_release].id}), "
    "decreasing torque limit by 1 every 100ms for up to 30s."
  )

  try:
    for _ in range(max_steps):
      current_torque_limit = max(0, current_torque_limit - 1)
      bus.write("Torque_Limit", motor_to_release, current_torque_limit, normalize=False)

      if input_stream is not None and q_pressed(input_stream):
        print("Soft release skipped by user.")
        break

      time.sleep(0.1)
      try:
        current_now = abs(int(bus.read("Present_Current", motor_to_release, normalize=False)))
        if current_now <= 1:
          break
      except Exception:
        pass
  except KeyboardInterrupt:
    print("\nSoft release interrupted; continuing shutdown.")


def reset_all_torque_limits_to_max(bus, motor_names=None):
  if motor_names is None:
    motor_names = bus.motors
  for motor_name in motor_names:
    bus.write("Torque_Limit", motor_name, 1000, normalize=False)
    bus.write("Max_Torque_Limit", motor_name, 1000, normalize=False)


def move_to_minimum_with_obstacle_stop(bus, input_stream=None):
  motor_names = list(bus.motors)
  if not motor_names:
    return False

  try:
    min_positions = {
      motor_name: int(bus.read("Min_Position_Limit", motor_name, normalize=False))
      for motor_name in motor_names
    }
    current_positions = {
      motor_name: int(bus.read("Present_Position", motor_name, normalize=False))
      for motor_name in motor_names
    }
  except Exception as exc:
    print(f"Could not initialize move-to-minimum check: {exc}")
    return False

  step_size = 8
  settle_time_s = 0.1
  max_iterations = 600

  print("\nMoving all motors smoothly to minimum positions...")

  try:
    for _ in range(max_iterations):
      goals = {}
      for motor_name in motor_names:
        cur = current_positions[motor_name]
        min_pos = min_positions[motor_name]
        goals[motor_name] = max(min_pos, cur - step_size)

      bus.sync_write("Goal_Position", goals, normalize=False)

      if input_stream is not None and q_pressed(input_stream):
        print("Move-to-minimum skipped by user.")
        return False

      time.sleep(settle_time_s)

      reached_all = True
      for motor_name in motor_names:
        pos = int(bus.read("Present_Position", motor_name, normalize=False))
        current_positions[motor_name] = pos

        if pos > min_positions[motor_name] + 2:
          reached_all = False

      if reached_all:
        print("Minimum positions reached for all motors.")
        return True

    print("Move-to-minimum timed out before all motors reached minimum.")
    return False
  except KeyboardInterrupt:
    print("\nMove-to-minimum interrupted; continuing shutdown.")
    return False


def run_check_after_reassembly(bus, stored_positions, tty_input, responding_motor_names=None):
  responding_motor_names = list(responding_motor_names or bus.motors)
  motion_settings = set_minimum_acceleration(bus, responding_motor_names)
  torque_limits = capture_torque_limits(bus, responding_motor_names)
  torque_enabled = False
  try:
    bus.enable_torque(motors=responding_motor_names)
    torque_enabled = True
    bus.sync_write("Goal_Position", stored_positions, normalize=False)

    interactive = tty_input is not None and sys.stdout.isatty()
    print("\nCheck after reassembly active. Moving slowly to stored snapshot positions. Press Q to quit.")

    if Table is not None and Console is not None and Live is not None and interactive:
      console = Console()
      with cbreak_mode(tty_input):
        with Live(
          make_rich_table(collect_rows(bus), "Check After Reassembly (press Q to quit)", stored_positions),
          console=console,
          refresh_per_second=10,
        ) as live:
          while True:
            live.update(
              make_rich_table(collect_rows(bus), "Check After Reassembly (press Q to quit)", stored_positions)
            )
            if q_pressed(tty_input):
              break
            time.sleep(0.1)
    else:
      if not interactive:
        print_plain_table(
          collect_rows(bus),
          "Check After Reassembly (non-interactive snapshot)",
          stored_positions,
        )
      else:
        with cbreak_mode(tty_input):
          while True:
            print("\033[2J\033[H", end="")
            print_plain_table(
              collect_rows(bus),
              "Check After Reassembly (press Q to quit)",
              stored_positions,
            )
            if q_pressed(tty_input):
              break
            time.sleep(0.15)
  finally:
    if torque_enabled:
      soft_release_torque(bus, torque_limits, tty_input)
      bus.disable_torque(motors=responding_motor_names)
      reset_all_torque_limits_to_max(bus, responding_motor_names)
    restore_motion_settings(bus, motion_settings)

handled_error = None
handled_error_log_path = None
unresponsive_motor_names = set()

try:
  teleop.connect(calibrate=False)
  bus = teleop.bus
except Exception as exc:
  missing_motor_ids = parse_missing_motor_ids(exc)
  if not missing_motor_ids:
    raise

  unresponsive_motor_names = {
    motor_name for motor_name, motor in teleop.bus.motors.items() if motor.id in missing_motor_ids
  }
  print_bold_red(
    "One or more motors are not responding during the handshake. Continuing with the expected motor list."
  )
  for motor_name in sorted(unresponsive_motor_names):
    print_bold_red(f"  - {motor_name}")
  if not teleop.bus.is_connected:
    teleop.bus.connect(handshake=False)
  teleop.bus.set_timeout()
  bus = teleop.bus

try:
  print("\nReading motors from bus...")
  rows = collect_rows(bus, unresponsive_motor_names)
  stored_positions = snapshot_positions(rows)
  has_unresponsive_motors = any(not row.get("responding") for row in rows)

  if Table is not None and Console is not None:
    console = Console()
    console.print(make_rich_table(rows, "Ernie Motor Readout (Snapshot)"))
  else:
    print_plain_table(rows, "Ernie Motor Readout (Snapshot)")

  try:
    tty_input = open("/dev/tty", "r")
  except OSError:
    tty_input = None

  interactive = tty_input is not None and sys.stdout.isatty()
  print("\nStarting live table. Press Q to stop.")

  if Table is not None and Console is not None and Live is not None and interactive:
    console = Console()
    with cbreak_mode(tty_input):
      with Live(
        make_rich_table(
          collect_rows(bus, unresponsive_motor_names),
          "Ernie Motor Readout (Live, press Q to quit)",
        ),
        console=console,
        refresh_per_second=10,
      ) as live:
        while True:
          live.update(
            make_rich_table(
              collect_rows(bus, unresponsive_motor_names),
              "Ernie Motor Readout (Live, press Q to quit)",
            )
          )
          if q_pressed(tty_input):
            break
          time.sleep(0.1)
  else:
    if not interactive:
      print("No interactive terminal detected for keypress capture; showing one additional snapshot.")
      print_plain_table(
        collect_rows(bus, unresponsive_motor_names),
        "Ernie Motor Readout (Second Snapshot)",
      )
    else:
      with cbreak_mode(tty_input):
        while True:
          print("\033[2J\033[H", end="")
          print_plain_table(
            collect_rows(bus, unresponsive_motor_names),
            "Ernie Motor Readout (Live, press Q to quit)",
          )
          if q_pressed(tty_input):
            break
          time.sleep(0.15)

  if has_unresponsive_motors:
    print_bold_red("Ignoring not responding motors during reassembly check; only responding motors will move.")
  if ask_yes_no_default_yes("\nRun check after reassembly? ([Y]/n) ", tty_input):
    responding_motor_names = [row["motor"] for row in rows if row.get("responding")]
    run_check_after_reassembly(bus, stored_positions, tty_input, responding_motor_names)
except Exception as exc:
  if is_power_connection_error(exc):
    handled_error_log_path = write_exception_log(exc, "power_connection_error")
    print_bold_red("Check power cable connection.")
    print(f"Error details logged to: {handled_error_log_path}", file=sys.stderr)
    handled_error = exc
  else:
    raise
finally:
  try:
    tty_input.close()
  except Exception:
    pass

  try:
    teleop.bus.disconnect(disable_torque=False)
  except Exception as cleanup_exc:
    if handled_error is not None:
      handled_error_log_path = write_exception_log(
        cleanup_exc,
        "cleanup_error_after_power_connection_error",
        handled_error_log_path,
      )
    else:
      raise

if handled_error is not None:
  sys.exit(1)
PY
