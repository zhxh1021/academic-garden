import json
import re
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1] / "godot-prototype"
SEED = ROOT / "data" / "garden_seed.json"
MAIN_SCRIPT = ROOT / "scripts" / "main.gd"
PAPER_MATURE_STAGES = {"tree", "flower", "fruit"}
PAPER_TREE_VARIETIES = {"ginkgo", "cherry", "maple", "pine", "willow", "camphor"}
ANIMATION_ROOT = ROOT / "assets" / "sprites" / "stage-animations" / "paper-trees"


def res_exists(path):
    return (ROOT / path.removeprefix("res://")).exists()


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    print(f"layout {data['layout_version']}")
    for zone in data["zones"]:
        xs = sorted({plot["x"] for plot in zone["plots"]})
        ys = sorted({plot["y"] for plot in zone["plots"]})
        print(f"{zone['id']} plots {len(zone['plots'])} decor {len(zone['decorations'])} xs {xs} ys {ys}")

    missing = []
    unstable_mature_stage_paths = []
    animation_errors = []
    for zone in data["zones"]:
        path = zone.get("map")
        if path and path.startswith("res://") and not res_exists(path):
            missing.append((zone["id"], "map", path))
        for plot in zone["plots"]:
            for key in ("sprite", "portrait_sprite"):
                path = plot.get(key)
                if path and path.startswith("res://") and not res_exists(path):
                    missing.append((plot["id"], key, path))
                if (
                    plot.get("kind") == "paper"
                    and plot.get("stage") in PAPER_MATURE_STAGES
                    and path
                    and not path.startswith("res://assets/sprites/web-normalized-stages/")
                ):
                    unstable_mature_stage_paths.append((plot["id"], key, path))
    for decor in data["decoration_catalog"]:
        path = decor["sprite"]
        if path.startswith("res://") and not res_exists(path):
            missing.append((decor["id"], "sprite", path))
    for path in sorted(set(re.findall(r'"(res://assets/[^"]+)"', MAIN_SCRIPT.read_text(encoding="utf-8")))):
        if "%" in path:
            continue
        if not res_exists(path):
            missing.append(("main.gd", "asset", path))

    print(f"missing {len(missing)}")
    for item in missing:
        print(item)
    if missing:
        raise SystemExit(1)

    for variety in sorted(PAPER_TREE_VARIETIES):
        for stage in sorted(PAPER_MATURE_STAGES):
            base_name = f"paper-{variety}-{stage}"
            source = ROOT / "assets" / "sprites" / "web-normalized-stages" / f"{base_name}.png"
            anim_dir = ANIMATION_ROOT / base_name
            if not source.exists():
                animation_errors.append((base_name, "missing source", source))
                continue
            if not anim_dir.exists():
                animation_errors.append((base_name, "missing animation dir", anim_dir))
                continue
            source_size = Image.open(source).size
            for frame_index in range(6):
                frame = anim_dir / f"frame-{frame_index:02d}.png"
                if not frame.exists():
                    animation_errors.append((base_name, "missing frame", frame))
                    continue
                frame_image = Image.open(frame).convert("RGBA")
                if frame_image.size != source_size:
                    animation_errors.append((base_name, "frame size mismatch", frame, frame_image.size, source_size))
                alpha = frame_image.getchannel("A")
                corners = [
                    alpha.getpixel((0, 0)),
                    alpha.getpixel((frame_image.size[0] - 1, 0)),
                    alpha.getpixel((0, frame_image.size[1] - 1)),
                    alpha.getpixel((frame_image.size[0] - 1, frame_image.size[1] - 1)),
                ]
                if any(corners):
                    animation_errors.append((base_name, "nontransparent corner", frame, corners))

    print(f"paper tree stage animation errors {len(animation_errors)}")
    for item in animation_errors:
        print(item)
    if animation_errors:
        raise SystemExit(1)

    main_text = MAIN_SCRIPT.read_text(encoding="utf-8")
    required_runtime_snippets = [
        "const LAYOUT_VERSION := 23",
        "_web_stage_sprite_path",
        "_web_stage_file_path",
        "res://assets/sprites/web-normalized-stages/%s.png",
        "TextureRect.STRETCH_SCALE",
        "animated_stage_textures",
        "_apply_stage_animation",
        "_stage_animation_frames",
        "res://assets/sprites/stage-animations/paper-trees/%s",
    ]
    forbidden_runtime_snippets = [
        "DISTINCT_MAP_STAGES",
        "_map_stage_sprite_path",
        "_map_stage_file_path",
        "button.clip_contents = true",
    ]
    for snippet in required_runtime_snippets:
        if snippet not in main_text:
            raise SystemExit(f"missing runtime sprite guard: {snippet}")
    for snippet in forbidden_runtime_snippets:
        if snippet in main_text:
            raise SystemExit(f"forbidden clipped/map-stage sprite behavior: {snippet}")

    print(f"unstable paper mature stage paths {len(unstable_mature_stage_paths)}")
    for item in unstable_mature_stage_paths:
        print(item)
    if unstable_mature_stage_paths:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
