#!/usr/bin/env zsh

lerobot-teleoperate \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id} \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id}
