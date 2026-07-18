#!/usr/bin/env zsh

# this script will run `lerobot-dataset-viz` to visualize a dataset.
# we source the .recordings.config file to get the repo_id and task_name.
# check if repo_id and task_name are set.
# then we need to pass the repo_id and task_name to the lerobot-dataset-viz command.
# we check how many episodes are recorded (repo_id meta data ???)
# and let user decide which episode to play back.


# sorce the init.recording.sh script to set up the environment and check for required parameters
set -a
source "$(dirname "$0")/.recording.config"
# reset the export option
set +a

# check if $repo_id and $task_name are set
# this is a double check, because init.recording.sh should have already checked for these variables.
# but maybe it did something unexpected.
if [ -z "$repo_id" ]; then
  echo "Error: repo_id is not set. Please set it to the name of the repository you want to use for training."
  exit 1
fi  

if [ -z "$task_name" ]; then
  echo "Error: task_name is not set. Please set it to the name of the task you want to train."
  exit 1
fi

dataset_root="/Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/${repo_id}"
info_json="${dataset_root}/meta/info.json"

if [ ! -f "$info_json" ]; then
  echo "Error: Could not find dataset metadata: $info_json"
  exit 1
fi

# `lerobot-dataset-viz` requires --episode-index and has no --list-episodes flag.
# Read the episode count from dataset metadata (`meta/info.json`).
num_episodes=$(awk -F: '/"total_episodes"[[:space:]]*:/ {gsub(/[^0-9]/, "", $2); print $2; exit}' "$info_json")

if [ -z "$num_episodes" ]; then
  echo "Error: Failed to read total_episodes from $info_json"
  exit 1
fi

if [ "$num_episodes" -le 0 ]; then
  echo "Error: Dataset has no episodes to visualize."
  exit 1
fi

echo "Number of episodes in dataset: $num_episodes"
# ask user which episode to visualize
read -r "?Enter the episode number to visualize (0 to $((num_episodes - 1))): " episode
# check if episode is a number and in range
if ! [[ "$episode" =~ ^[0-9]+$ ]] || [ "$episode" -lt 0 ] || [ "$episode" -ge "$num_episodes" ]; then
  echo "Error: Invalid episode number. Please enter a number between 0 and $((num_episodes - 1))."
  exit 1
fi


lerobot-dataset-viz \
    --repo-id garagelab-duesseldorf/${repo_id} \
  --root "$dataset_root" \
    --mode local \
    --episode-index "$episode"