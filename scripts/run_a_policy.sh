#!/usr/bin/env zsh

echo "Start running a policy on the robot..."
echo

echo "First clean-up cache for the dataset to avoid any potential issues with previous runs."
echo


rm -rf /Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/eval_record-test-05

# add a check, if last command exited with no error
if [ $? -ne 0 ]; then
    echo "Error: Failed to clean up cache for the dataset."
    exit 1
else
    echo "Cache cleaned successfully."
fi

echo "Now running the policy on the robot..."
echo

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