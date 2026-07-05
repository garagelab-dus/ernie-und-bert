#!/bin/sh

echo "Now calibrating teleoperation devices..."
echo "Teleoperation Type: ${bert_type}, Teleoperation Port: ${bert_port}, Teleoperation ID: ${bert_id}"
echo "Please follow the instructions on screen for teleoperation calibration."

lerobot-calibrate \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id}
    


    