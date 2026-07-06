#!/usr/bin/env zsh

echo "Starting calibration for robot devices..."
echo "Robot Type: ${ernie_type}"
echo "Robot Port: ${ernie_port}"
echo "Robot ID: ${ernie_id}"
echo "Please follow the instructions on screen."
echo

lerobot-calibrate \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id}

echo "Calibration for robot devices completed."
