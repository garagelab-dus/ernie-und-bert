#!/usr/bin/env zsh

echo "Start rolling out a policy on the robot..."
echo

# echo "First clean-up cache for the dataset to avoid any potential issues with previous runs."
# echo


# rm -rf /Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/eval_record-test-05

# add a check, if last command exited with no error
# if [ $? -ne 0 ]; then
#     echo "Error: Failed to clean up cache for the dataset."
#     exit 1
# else
#     echo "Cache cleaned successfully."
# fi
# 
echo "Now rolling rolling rolling the policy on the robot..."
echo "..."
echo "..."
echo 
echo "OUT."

lerobot-rollout \
  --strategy.type=base \
  --policy.path="garagelab-duesseldorf/pap_green_foam_in_box-policy-v4a" \
  --policy.device=mps \
  --robot.type=${ernie_type} \
  --robot.port=${ernie_port} \
  --robot.cameras=${robot_cameras2} \
  --robot.id=${ernie_id} \
  --task="Put green foam in a box" \
  --duration=600


#  --dataset.repo_id="garagelab-duesseldorf/eval_pap_green_foam_in_box" \
#  --dataset.push_to_hub=false \
#  --display_data=false \
#  --teleop.type=${bert_type} \
#  --teleop.port=${bert_port} \
#  --teleop.id=${bert_id} \
  # \
  # --wandb.enabled=true \
  # --wandb.type=offline
