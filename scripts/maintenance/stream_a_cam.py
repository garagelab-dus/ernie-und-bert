#!/usr/bin/env python3
"""Select a camera from camera_assignments.json and stream it with VLC.

Default behavior launches VLC CLI with avcapture://<unique_id>.
Use --use-python-vlc to force python-vlc playback.
Use --print-url to only print the URL to stdout.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Select and stream a camera")
    parser.add_argument(
        "--print-url",
        action="store_true",
        help="print avcapture URL to stdout instead of launching a player",
    )
    parser.add_argument(
        "--use-vlc-cli",
        action="store_true",
        help="launch VLC binary (default playback mode)",
    )
    parser.add_argument(
        "--use-python-vlc",
        action="store_true",
        help="use python-vlc playback instead of VLC CLI",
    )
    return parser.parse_args()


def maybe_reexec_with_conda_python() -> None:
    """Relaunch with CONDA_PREFIX/bin/python when current interpreter is outside env."""
    conda_prefix = os.environ.get("CONDA_PREFIX")
    if not conda_prefix:
        return

    conda_python = (Path(conda_prefix) / "bin" / "python").resolve()
    if not conda_python.exists():
        return

    try:
        current_python = Path(sys.executable).resolve()
    except OSError:
        return

    if current_python == conda_python:
        return

    os.execv(str(conda_python), [str(conda_python), *sys.argv])


def launch_with_vlc_cli(url: str) -> int:
    vlc_bin = shutil.which("vlc")

    # Common macOS app bundle fallback when VLC is installed but not on PATH.
    if not vlc_bin and sys.platform == "darwin":
        app_vlc = "/Applications/VLC.app/Contents/MacOS/VLC"
        if Path(app_vlc).exists():
            vlc_bin = app_vlc

    if not vlc_bin:
        print(
            "Error: VLC binary not found. Install VLC app/CLI or use python-vlc mode.",
            file=sys.stderr,
        )
        return 1

    # Launch VLC in foreground so Ctrl+C in this terminal can stop it.
    return subprocess.call([vlc_bin, url])


def launch_with_python_vlc(url: str) -> int:
    try:
        import vlc
    except ImportError as exc:
        print(
            "Error: failed to import python-vlc with interpreter "
            f"{sys.executable}: {exc}. "
            "Try running with your conda env Python or use --use-vlc-cli.",
            file=sys.stderr,
        )
        return 1

    # Help python-vlc find libvlc when VLC is installed as a macOS app.
    if sys.platform == "darwin":
        os.environ.setdefault("PYTHON_VLC_MODULE_PATH", "/Applications/VLC.app/Contents/MacOS/plugins")
        os.environ.setdefault("PYTHON_VLC_LIB_PATH", "/Applications/VLC.app/Contents/MacOS/lib/libvlc.dylib")

    try:
        instance = vlc.Instance("--no-video-title-show")
        player = instance.media_player_new()
        media = instance.media_new(url)
        player.set_media(media)
        play_result = player.play()
    except Exception as exc:
        print(
            f"Error: unable to start python-vlc playback ({exc}). "
            "If VLC.app is installed, try --use-vlc-cli.",
            file=sys.stderr,
        )
        return 1

    if play_result == -1:
        print("Error: failed to start stream playback.", file=sys.stderr)
        return 1

    print("Streaming... Press Ctrl+C to stop.", file=sys.stderr)
    try:
        while True:
            state = player.get_state()
            if state in {vlc.State.Ended, vlc.State.Error, vlc.State.Stopped}:
                break
            time.sleep(0.2)
    except KeyboardInterrupt:
        pass
    finally:
        player.stop()

    return 0


def main() -> int:
    args = parse_args()

    # Ensure python-vlc runs in the active conda env even when ./script uses a different python3 on PATH.
    if args.use_python_vlc and not args.print_url:
        maybe_reexec_with_conda_python()

    script_dir = Path(__file__).resolve().parent
    assignments_path = script_dir / "camera_assignments.json"

    try:
        data = json.loads(assignments_path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        print(f"Error: file not found: {assignments_path}", file=sys.stderr)
        return 1
    except json.JSONDecodeError as exc:
        print(f"Error: invalid JSON in {assignments_path}: {exc}", file=sys.stderr)
        return 1

    if not isinstance(data, dict) or not data:
        print(f"Error: expected a non-empty object in {assignments_path}", file=sys.stderr)
        return 1

    items = list(data.items())

    print("Select a camera:", file=sys.stderr)
    for idx, (key, name) in enumerate(items, start=1):
        print(f"  {idx}. {name} ({key})", file=sys.stderr)
    print("  q. quit", file=sys.stderr)

    while True:
        print("Enter number (or q): ", end="", file=sys.stderr, flush=True)
        choice = input().strip()
        if choice.lower() == "q":
            print("Cancelled.", file=sys.stderr)
            return 0

        if not choice.isdigit():
            print("Please enter a valid number or 'q'.", file=sys.stderr)
            continue

        index = int(choice)
        if 1 <= index <= len(items):
            selected_key = items[index - 1][0]
            url = f"avcapture://{selected_key}"

            if args.print_url:
                print(url)
                return 0

            if args.use_python_vlc:
                return launch_with_python_vlc(url)

            return launch_with_vlc_cli(url)

        print(f"Please enter a number between 1 and {len(items)}.", file=sys.stderr)


if __name__ == "__main__":
    raise SystemExit(main())