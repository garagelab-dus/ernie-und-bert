#!/usr/bin/env zsh
## script for uploading dataset recordings.
#
## manual steps:
# lerobot@Mac:garagelab-duesseldorf/multi_episode $ echo $recording_local 
# /Users/lerobot/.cache/huggingface/lerobot/garagelab-duesseldorf/multi_episode
# lerobot@Mac:garagelab-duesseldorf/multi_episode $ hf upload ${HF_USER}/${dataset_name} $recording_local --repo-type dataset 
# Found 48 files to upload
#   Preparing   ████████████████████  48 / 48 ✓
#   Uploading   ████████████████████  45 / 45 files  2.04GB · 1.19MB/s ✓
#   Committing  ████████████████████  48 / 48 ✓
# ✓ Uploaded
#   url: https://huggingface.co/datasets/garagelab-duesseldorf/pap_green_foam_in_box/commit/3ede4b5b783059312249fa7c0ffd7417328960d9
# lerobot@Mac:garagelab-duesseldorf/multi_episode $ echo $HF_USER
# garagelab-duesseldorf
# lerobot@Mac:garagelab-duesseldorf/multi_episode $ HF_USER="garagelab-duesseldorf" dataset_name=${task_name}

# ---

# check if hf auth whoami returns a user, else exit with error
if ! hf whoami &> /dev/null; then
  echo "Error: You are not logged in to Hugging Face. Please run 'hf login' to log in."
  exit 1
fi

HF_USER="garagelab-duesseldorf"
dataset_name=${task_name}

# hf upload ${HF_USER}/${dataset_name} ~/.cache/huggingface/lerobot/${repo_id} --repo-type dataset

