# Plan: Update LeRobot In Conda Without Breaking Existing Setup

## Goal

Use our edited LeRobot source in lerobot submodule, while keeping the current working environment unchanged.

## Why This Is Needed

- Current CLI in active environment is older (requires --episode-index only).
- Submodule source includes our new multi-episode Rerun support.
- We need a safe migration path for ourselves and teammates.

## Safety Strategy

1. Do not touch current conda environment in place.
2. Create a cloned conda environment from the working one.
3. Install LeRobot from local submodule source in editable mode inside cloned env only.
4. Validate CLI behavior and scripts.
5. Share exact commands and checks with team.

## Git Strategy Before Any Installation

1. Create a feature branch for all source changes and docs.
2. Commit changes there.
3. Keep main branch clean.

Suggested:

- git checkout -b feat/lerobot-multi-episode-rerun

## Conda Upgrade Procedure (Safe)

### Step 1: Identify current env name

- conda info --envs

Example assumptions below:

- source env name: robot
- new env name: robot-lerobot-src

### Step 2: Clone env

- conda create --name robot-lerobot-src --clone robot

### Step 3: Activate cloned env

- conda activate robot-lerobot-src

### Step 4: Install LeRobot from local submodule source

Run from workspace root:

- cd /Users/lerobot/repos/ernie-und-bert/lerobot
- python -m pip install -e .

If required extras are missing for dataset viz:

- python -m pip install -e .[dataset,viz,core_scripts]

Note: Use quotes around extras if your shell expands brackets.

## Validation Checklist

### 1) Confirm active binary and import path

- which lerobot-dataset-viz
- python -c "import lerobot, inspect; print(inspect.getfile(lerobot))"

Expected: path points to local workspace/submodule, not site-packages wheel copy.

### 2) Confirm new CLI options are available

- lerobot-dataset-viz --help

Expected: help includes --episode-indices.

### 3) Run hardcoded script

- cd /Users/lerobot/repos/ernie-und-bert/scripts
- python3 replay-episode-selection.py

Expected behavior:

- either one multi-episode run if --episode-indices exists
- or fallback sequential replay if old CLI is still used

### 4) Force check that new source is used

If help still does not show --episode-indices:

1. Verify you are in cloned env.
2. Re-run editable install in that env.
3. Re-check which lerobot-dataset-viz.

## Rollback

At any time:

1. conda deactivate
2. conda activate robot

No changes should affect original environment.

## Team Communication Template

Subject: Safe LeRobot source upgrade for multi-episode Rerun

Summary:

- We added multi-episode Rerun support in local LeRobot source.
- Do not update your existing env in place.
- Clone your current env, install LeRobot editable from submodule, run validation checks.

Required steps:

1. conda create --name <new_env> --clone <current_env>
2. conda activate <new_env>
3. cd /Users/lerobot/repos/ernie-und-bert/lerobot
4. python -m pip install -e .
5. lerobot-dataset-viz --help and verify --episode-indices is present

Acceptance checks:

- local import path points to workspace source
- replay script works in Rerun with selected episodes

## Open Decision

Should we also pin and export an environment file for team reproducibility after validation?

Suggested next step after successful validation:

- conda env export --name robot-lerobot-src > scripts/env.robot-lerobot-src.yml
