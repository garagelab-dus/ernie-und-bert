#!/usr/bin/env zsh

source "$(dirname "$0")/init.cameras.sh"

# check if robot_cameras2 is set, otherwise exit with error
: "${robot_cameras2:?robot_cameras2 must be set}"

# print out the camera values for confirmation
# we accept ENTER as confirmation, and any other key will exit.
echo "robot_cameras2: $robot_cameras2"
read -r "?Press ENTER to continue or any other key to abort." input
if [ -n "$input" ]; then
  echo "Aborted."
  exit 1
fi

lerobot-teleoperate \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id} \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id} \
    --robot.cameras=${robot_cameras2} \
    --display_data=true \
    --fps=30 
