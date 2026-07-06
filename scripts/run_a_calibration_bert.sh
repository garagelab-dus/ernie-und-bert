#!/usr/bin/env zsh

echo "Now calibrating teleoperation devices..."
echo "Teleoperation Type: ${bert_type}"
echo "Teleoperation Port: ${bert_port}"
echo "Teleoperation ID: ${bert_id}"
echo "Please follow the instructions on screen for teleoperation calibration."
echo

lerobot-calibrate \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id}
    
echo "Calibration for teleoperation devices completed."

    