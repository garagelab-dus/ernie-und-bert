#!/usr/bin/env zsh

echo "Starting calibration for robot and teleoperation devices..."
echo "Robot Type: ${ernie_type}, Robot Port: ${ernie_port}, Robot ID: ${ernie_id}"
echo "Please follow the instructions on screen."

lerobot-calibrate \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id}

echo "Now calibrating teleoperation devices..."
echo "Teleoperation Type: ${bert_type}, Teleoperation Port: ${bert_port}, Teleoperation ID: ${bert_id}"
echo "Please follow the instructions on screen for teleoperation calibration."

lerobot-calibrate \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id}
    

