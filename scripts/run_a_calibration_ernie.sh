#!/bin/sh

echo "Starting calibration for robot and teleoperation devices..."
echo "Robot Type: ${ernie_type}, Robot Port: ${ernie_port}, Robot ID: ${ernie_id}"
echo "Please follow the instructions on screen."

lerobot-calibrate \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id}