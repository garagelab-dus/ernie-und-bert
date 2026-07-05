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


episode=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --episode)
      if [[ -z "$2" ]]; then
        echo "Error: --episode requires an INT value"
        exit 1
      fi
      episode="$2"
      shift 2
      ;;
    *)
      echo "Error: Unknown argument: $1"
      echo "Usage: $0 [--episode 0]"
      exit 1
      ;;
  esac
done


lerobot-replay \
    --robot.type=${ernie_type} \
    --robot.port=${ernie_port} \
    --robot.id=${ernie_id} \
    --dataset.repo_id=garagelab-duesseldorf/${repo_id} \
    --dataset.episode=$episode # choose the episode you want to replay

echo "Task $task_name, episode: $episode finished."
echo
