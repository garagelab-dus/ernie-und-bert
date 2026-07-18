#!/usr/bin/env python3

"""Hardcoded local test: load 2 episodes and replay them in Rerun.

This mirrors the strategy from lerobot's dataset tools:
- use multi-episode selection in lerobot-dataset-viz (Rerun mode)
- keep Foxglove out (single-episode only)
"""

from pathlib import Path
import shutil
import subprocess

def main() -> None:
    task_name = "pap_green_foam_in_box"
    repo_id = "test-usb-cable"
    episode_indices = [1, 2]

    full_repo_id = f"garagelab-duesseldorf/{repo_id}"
    dataset_root = Path(f"/Users/lerobot/.cache/huggingface/lerobot/{full_repo_id}")
    info_json = dataset_root / "meta" / "info.json"

    if not info_json.exists():
        raise FileNotFoundError(f"Missing dataset metadata: {info_json}")

    if shutil.which("lerobot-dataset-viz") is None:
        raise RuntimeError(
            "`lerobot-dataset-viz` is not available in PATH. "
            "Activate the environment where lerobot CLI tools are installed, then re-run."
        )

    print(f"Task: {task_name}")
    print(f"Dataset: {full_repo_id}")
    print(f"Episodes: {episode_indices}")

    help_result = subprocess.run(
        ["lerobot-dataset-viz", "--help"],
        check=False,
        capture_output=True,
        text=True,
    )
    supports_multi_episode = "--episode-indices" in (help_result.stdout + help_result.stderr)

    if supports_multi_episode:
        cmd = [
            "lerobot-dataset-viz",
            "--repo-id",
            full_repo_id,
            "--root",
            str(dataset_root),
            "--mode",
            "local",
            "--display-mode",
            "rerun",
            "--episode-indices",
            *[str(ep) for ep in episode_indices],
        ]
        subprocess.run(cmd, check=True)
        return

    print(
        "Installed lerobot-dataset-viz does not support --episode-indices. "
        "Falling back to sequential single-episode playback."
    )
    for episode in episode_indices:
        print(f"Launching episode {episode}...")
        cmd = [
            "lerobot-dataset-viz",
            "--repo-id",
            full_repo_id,
            "--root",
            str(dataset_root),
            "--mode",
            "local",
            "--episode-index",
            str(episode),
        ]
        subprocess.run(cmd, check=True)


if __name__ == "__main__":
    main()
