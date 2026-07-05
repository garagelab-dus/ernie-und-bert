#!/usr/bin/env python3

"""Interactive camera labeling assistant for macOS AVFoundation/UVC cameras.

Flow:
1. Discover cameras via `system_profiler SPCameraDataType -json`.
2. Keep only cameras whose Unique ID starts with "0x" (typically external UVC).
3. Let user select a camera by Model ID / Unique ID.
4. Capture one snapshot from the selected camera using ffmpeg + AVFoundation.
5. Open snapshot with macOS `open`.
6. Ask for label: wrist / shoulder / custom.
7. Save labels to JSON mapping file.
"""

from __future__ import annotations

import json
import re
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT_DIR = ROOT / "camera_snapshots"
DEFAULT_MAPPING_PATH = ROOT / "camera_assignments.json"
DEFAULT_INDEX_BINDING_PATH = ROOT / "camera_index_bindings.json"


@dataclass
class CameraInfo:
    name: str
    model_id: str
    unique_id: str
    ffmpeg_index: int | None = None


def run_command(cmd: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=False, text=True, capture_output=True)


def get_profiler_cameras() -> list[CameraInfo]:
    result = run_command(["system_profiler", "SPCameraDataType", "-json"])
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "system_profiler failed")

    payload = json.loads(result.stdout)
    rows = payload.get("SPCameraDataType", [])

    cameras: list[CameraInfo] = []
    for row in rows:
        name = str(row.get("_name", "")).strip()
        model_id = str(row.get("spcamera_model-id", "")).strip()
        unique_id = str(row.get("spcamera_unique-id", "")).strip()
        if unique_id.startswith("0x"):
            cameras.append(CameraInfo(name=name, model_id=model_id, unique_id=unique_id))

    return cameras


def parse_ffmpeg_video_devices(stderr_text: str) -> dict[int, str]:
    devices: dict[int, str] = {}
    in_video_section = False

    for raw_line in stderr_text.splitlines():
        line = raw_line.strip()
        if "AVFoundation video devices:" in line:
            in_video_section = True
            continue
        if "AVFoundation audio devices:" in line:
            break
        if not in_video_section:
            continue

        match = re.search(r"\[(\d+)\]\s+(.+)$", line)
        if match:
            index = int(match.group(1))
            name = match.group(2).strip()
            devices[index] = name

    return devices


def get_ffmpeg_video_devices() -> dict[int, str]:
    result = run_command(["ffmpeg", "-f", "avfoundation", "-list_devices", "true", "-i", ""])
    if result.returncode == 127:
        raise RuntimeError("ffmpeg not found in PATH")
    return parse_ffmpeg_video_devices(result.stderr)


def normalize_name(name: str) -> str:
    return " ".join(name.strip().split())


def attach_ffmpeg_indices(cameras: list[CameraInfo], video_devices: dict[int, str]) -> None:
    # Multiple cameras can share the same AVFoundation name. Assign indices by
    # occurrence order so cameras with identical names can still map distinctly.
    name_to_indices: dict[str, list[int]] = {}
    for index, device_name in sorted(video_devices.items()):
        key = normalize_name(device_name)
        name_to_indices.setdefault(key, []).append(index)

    name_seen_count: dict[str, int] = {}
    for cam in cameras:
        key = normalize_name(cam.name)
        occ = name_seen_count.get(key, 0)
        indices = name_to_indices.get(key, [])
        cam.ffmpeg_index = indices[occ] if occ < len(indices) else None
        name_seen_count[key] = occ + 1


def load_existing_mapping(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def save_mapping(path: Path, mapping: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(mapping, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def load_index_bindings(path: Path) -> dict[str, int]:
    if not path.exists():
        return {}
    try:
        raw = json.loads(path.read_text(encoding="utf-8"))
        return {str(k): int(v) for k, v in raw.items()}
    except Exception:
        return {}


def save_index_bindings(path: Path, bindings: dict[str, int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(bindings, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def bind_cameras_to_indices(
    cameras: list[CameraInfo],
    video_devices: dict[int, str],
    saved_bindings: dict[str, int],
) -> dict[str, int]:
    """Assign each Unique ID a stable ffmpeg index.

    Priority:
    1) keep previously saved Unique ID -> index when valid,
    2) deterministically assign remaining cameras by name group and Unique ID order.
    """
    name_to_indices: dict[str, list[int]] = {}
    for index, device_name in sorted(video_devices.items()):
        key = normalize_name(device_name)
        name_to_indices.setdefault(key, []).append(index)

    used_indices: set[int] = set()
    result_bindings: dict[str, int] = {}

    # Reuse valid saved bindings first.
    for cam in cameras:
        saved_index = saved_bindings.get(cam.unique_id)
        if saved_index is None:
            continue
        key = normalize_name(cam.name)
        if saved_index in name_to_indices.get(key, []):
            cam.ffmpeg_index = saved_index
            used_indices.add(saved_index)
            result_bindings[cam.unique_id] = saved_index
        else:
            cam.ffmpeg_index = None

    # Deterministically assign remaining cameras.
    cameras_by_name: dict[str, list[CameraInfo]] = {}
    for cam in cameras:
        if cam.ffmpeg_index is not None:
            continue
        cameras_by_name.setdefault(normalize_name(cam.name), []).append(cam)

    for name_key, cams in cameras_by_name.items():
        available = [idx for idx in name_to_indices.get(name_key, []) if idx not in used_indices]
        available.sort()
        cams.sort(key=lambda c: c.unique_id)
        for cam, idx in zip(cams, available):
            cam.ffmpeg_index = idx
            used_indices.add(idx)
            result_bindings[cam.unique_id] = idx

    # Persist already-bound cameras too.
    for cam in cameras:
        if cam.ffmpeg_index is not None and cam.unique_id not in result_bindings:
            result_bindings[cam.unique_id] = cam.ffmpeg_index

    return result_bindings


def capture_snapshot(cam: CameraInfo) -> Path:
    if cam.ffmpeg_index is None:
        raise RuntimeError("Camera has no AVFoundation index match")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    safe_id = cam.unique_id.replace("/", "_")
    out = OUTPUT_DIR / f"snapshot_{safe_id}_{stamp}.jpg"

    cmd = [
        "ffmpeg",
        "-y",
        "-f",
        "avfoundation",
        "-framerate",
        "30",
        "-i",
        f"{cam.ffmpeg_index}:none",
        "-frames:v",
        "1",
        str(out),
    ]
    result = run_command(cmd)
    if result.returncode != 0:
        err = (result.stderr or "").strip()
        raise RuntimeError(err or "Failed to capture snapshot")

    return out


def prompt_yes_default_no(prompt: str) -> bool:
    reply = input(prompt).strip().lower()
    return reply in {"y", "yes"}


def open_snapshot(path: Path) -> None:
    run_command(["open", str(path)])


def prompt_selection(cameras: list[CameraInfo]) -> int | None:
    print("\nAvailable UVC cameras:")
    for idx, cam in enumerate(cameras, start=1):
        ff_idx = "?" if cam.ffmpeg_index is None else str(cam.ffmpeg_index)
        print(
            f"  {idx}. Model ID: {cam.model_id} | Unique ID: {cam.unique_id} "
            f"| Name: {cam.name} | FFmpeg index: {ff_idx}"
        )

    while True:
        reply = input("Select a camera number (or q to quit): ").strip().lower()
        if reply == "q":
            return None
        if reply.isdigit():
            value = int(reply)
            if 1 <= value <= len(cameras):
                return value - 1
        print("Invalid selection.")


def prompt_label(current_label: str | None) -> str | None:
    if current_label:
        print(f"Current label: {current_label}")

    print("Assign label:")
    print("  1) wrist")
    print("  2) shoulder")
    print("  3) custom")
    print("  4) keep current")

    while True:
        reply = input("Choose [1/2/3/4]: ").strip()
        if reply == "1":
            return "wrist"
        if reply == "2":
            return "shoulder"
        if reply == "3":
            custom = input("Enter custom label: ").strip()
            if custom:
                return custom
            print("Custom label cannot be empty.")
            continue
        if reply == "4":
            return None
        print("Invalid selection.")


def main() -> int:
    try:
        cameras = get_profiler_cameras()
    except Exception as exc:
        print(f"Error while reading cameras from system_profiler: {exc}", file=sys.stderr)
        return 1

    if not cameras:
        print("No UVC cameras found (Unique ID starting with '0x').")
        return 1

    index_binding_path = DEFAULT_INDEX_BINDING_PATH
    index_bindings = load_index_bindings(index_binding_path)

    try:
        video_devices = get_ffmpeg_video_devices()
        index_bindings = bind_cameras_to_indices(cameras, video_devices, index_bindings)
        save_index_bindings(index_binding_path, index_bindings)
    except Exception as exc:
        print(f"Error while reading AVFoundation devices via ffmpeg: {exc}", file=sys.stderr)
        return 1

    mapping_path = DEFAULT_MAPPING_PATH
    mapping = load_existing_mapping(mapping_path)

    while True:
        selection = prompt_selection(cameras)
        if selection is None:
            break

        cam = cameras[selection]

        # Refresh mapping each capture but keep stable Unique ID -> index bindings.
        try:
            video_devices = get_ffmpeg_video_devices()
            index_bindings = bind_cameras_to_indices(cameras, video_devices, index_bindings)
            save_index_bindings(index_binding_path, index_bindings)
        except Exception as exc:
            print(f"Could not refresh ffmpeg devices: {exc}", file=sys.stderr)
            continue

        cam = cameras[selection]

        print(f"\nCapturing snapshot for {cam.model_id} ({cam.unique_id})...")
        try:
            snapshot_path = capture_snapshot(cam)
        except Exception as exc:
            print(f"Snapshot capture failed: {exc}", file=sys.stderr)
            continue

        open_snapshot(snapshot_path)
        print(f"Snapshot opened: {snapshot_path}")

        label = prompt_label(mapping.get(cam.unique_id))
        if label is not None:
            mapping[cam.unique_id] = label
            save_mapping(mapping_path, mapping)
            print(f"Saved: {cam.unique_id} -> {label}")
            print(f"Mapping file: {mapping_path}")

        # Default to stopping after one camera to avoid accidental repeated relabeling.
        if not prompt_yes_default_no("Configure another camera? (y/[N]) "):
            break

    if mapping:
        save_mapping(mapping_path, mapping)
        print(f"\nFinal mapping saved to: {mapping_path}")
    else:
        print("\nNo camera labels were saved.")

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        print("\nCamera assistant canceled by user.")
        raise SystemExit(130)
