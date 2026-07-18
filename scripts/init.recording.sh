#!/usr/bin/env zsh
# Make the parameter values from `./.recording.config` accessible to other scripts.

# example
# export task_name=recording.config.task_name.value

# export everything in the .recording.config file
set -a
source "$(dirname "$0")/.recording.config"
# reset the export option
set +a

# check if task_name and repo_id are set, otherwise exit with error
: "${task_name:?task_name or TASK_NAME must be set}"
: "${repo_id:?repo_id or REPO_ID must be set}"

# if we reach this point, both vars exist in config file.
# local script var (lowercase) falls back to env-style var (UPPERCASE)
task_name="${task_name:-$TASK_NAME}"
repo_id="${repo_id:-$REPO_ID}"

# check, if repo_id already exists.
# if true, write a warning that repo_id cache will be cleared.
if [ -d "/Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/${repo_id}" ]; then
  echo "Warning: The repository garagelab-duesseldorf/${repo_id} already exists in the cache."
  echo "The cache will be cleared before starting the training."
else
  echo "The repository garagelab-duesseldorf/${repo_id} does not exist in the cache."
  echo "Initializing training:"
  echo "task: ${task_name}"
  echo "repository: ${repo_id}."
fi
# ask for confirmation to continue
# User must press ENTER to continue or any key to abort.
# if ENTER we exit with success, otherwise we exit with 1
read -r "?Press ENTER to continue or any other key to abort." input
if [ -n "$input" ]; then
  echo "Aborted."
  exit 1
fi


