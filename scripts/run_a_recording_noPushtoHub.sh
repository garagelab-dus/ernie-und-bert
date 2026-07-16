#!/usr/bin/env zsh

# check if $repo_id and $task_name are set
if [ -z "$repo_id" ]; then
  echo "Error: repo_id is not set. Please set it to the name of the repository you want to use for training."
  exit 1
fi

if [ -z "$task_name" ]; then
  echo "Error: task_name is not set. Please set it to the name of the task you want to train."
  exit 1
fi

# cleaning cache locally
rm -rf /Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/${repo_id}; 

echo "Cache cleared for repository garagelab-duesseldorf/${repo_id}."
echo "Starting training for task ${task_name} using repository garagelab-duesseldorf/${repo_id}."


# start training

lerobot-record \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id} \
    --robot.cameras='{ front: { type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30 }, wrist: { type: opencv, index_or_path: 1, width: 640, height: 480, fps: 30 }}' \
    --teleop.type=${bert_type} \
    --teleop.port=${bert_port} \
    --teleop.id=${bert_id} \
    --display_data=true \
    --dataset.repo_id=garagelab-duesseldorf/${repo_id} \
    --dataset.num_episodes=1 \
    --dataset.push_to_hub=False \
    --dataset.episode_time_s=60 \
    --dataset.reset_time_s=60 \
    --dataset.fps=30 \
    --dataset.single_task=${task_name} \
    --dataset.streaming_encoding=true \
    --dataset.encoder_threads=2 

    # --dataset.num_episodes IST IMMER DIE ANZAHL DER AUFZUNEHMENDEN EPISODEN
    # die nächsten zwei parameter sorgen dafür, das die vorherigen episoden bestehen bleiben
    # --resume=true
    # --dataset.root="/Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/${repo_id}"

