#!/bin/zsh

rm -rf /Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/eval_record-test-05

lerobot-record \
  --robot.type=${ernie_type} \
  --robot.port=${ernie_port} \
  --robot.cameras=${robot_cameras2} \
  --robot.id=${ernie_id} \
  --teleop.type=${bert_type} \
  --teleop.port=${bert_port} \
  --teleop.id=${bert_id} \
  --display_data=false \
  --dataset.repo_id="garagelab-duesseldorf/eval_record-test-05" \
  --dataset.single_task="Grab sponge from a box" \
  --dataset.push_to_hub=false \
  --policy.path="./policies/040000/pretrained_model" \
  --policy.device=mps 