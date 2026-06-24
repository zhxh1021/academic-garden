import json
import re
from pathlib import Path
from collections import deque

from PIL import Image


ROOT = Path(__file__).resolve().parents[1] / "godot-prototype"
SEED = ROOT / "data" / "garden_seed.json"
MAIN_SCRIPT = ROOT / "scripts" / "main.gd"
RULE_SCRIPTS = [
    ROOT / "scripts" / "layout_rules.gd",
    ROOT / "scripts" / "plant_rules.gd",
]
PAPER_MATURE_STAGES = {"tree", "flower", "fruit"}
PAPER_TREE_VARIETIES = {"ginkgo", "cherry", "maple", "pine", "willow", "camphor"}
ANIMATION_ROOT = ROOT / "assets" / "sprites" / "stage-animations" / "paper-trees"
REQUIRED_AUDIO_IMPORTS = [
    ROOT / "assets" / "audio" / "garden_bgm_main_loop.wav.import",
    ROOT / "assets" / "audio" / "garden_bgm_dormant_loop.wav.import",
]
REQUIRED_UI_SPRITES = [
    ROOT / "assets" / "sprites" / "ui" / "seed-shop-gpt-v1.png",
    ROOT / "assets" / "sprites" / "ui" / "seed-locked-gpt-v1.png",
]
MIN_STAGE_SAFE_MARGIN_PX = 8
FINAL_COURSE_STAGES = {"blossom", "seed_saved"}


def res_exists(path):
    return (ROOT / path.removeprefix("res://")).exists()


def alpha_margins(path):
    image = Image.open(path).convert("RGBA")
    bbox = image.getchannel("A").getbbox()
    if not bbox:
        return image.size, None
    left, top, right, bottom = bbox
    width, height = image.size
    return image.size, (left, top, width - right, height - bottom)


def contains_magenta_chroma_residue(path):
    image = Image.open(path).convert("RGBA")
    for red, green, blue, alpha in image.getdata():
        if alpha and red >= 170 and blue >= 170 and green <= 95 and abs(red - blue) <= 90:
            return True
    return False


def significant_alpha_component_count(path):
    image = Image.open(path).convert("RGBA")
    alpha = image.getchannel("A")
    width, height = image.size
    seen = bytearray(width * height)
    significant_components = 0
    for start_y in range(height):
        for start_x in range(width):
            start_index = start_y * width + start_x
            if seen[start_index] or alpha.getpixel((start_x, start_y)) == 0:
                seen[start_index] = 1
                continue
            queue = deque([(start_x, start_y)])
            seen[start_index] = 1
            size = 0
            while queue:
                x, y = queue.popleft()
                size += 1
                for next_x, next_y in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                    if next_x < 0 or next_y < 0 or next_x >= width or next_y >= height:
                        continue
                    next_index = next_y * width + next_x
                    if seen[next_index]:
                        continue
                    seen[next_index] = 1
                    if alpha.getpixel((next_x, next_y)) != 0:
                        queue.append((next_x, next_y))
            if size > 8:
                significant_components += 1
    return significant_components


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
    script_texts = [MAIN_SCRIPT.read_text(encoding="utf-8")]
    for script in RULE_SCRIPTS:
        if script.exists():
            script_texts.append(script.read_text(encoding="utf-8"))
    for path in sorted(set(re.findall(r'"(res://assets/[^"]+)"', "\n".join(script_texts)))):
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

    safe_margin_errors = []
    course_slice_errors = []
    stage_root = ROOT / "assets" / "sprites" / "web-normalized-stages"
    for source in sorted(stage_root.glob("course-*.png")):
        size, margin = alpha_margins(source)
        if margin is None or min(margin) < MIN_STAGE_SAFE_MARGIN_PX:
            safe_margin_errors.append((source.name, size, margin))
        if contains_magenta_chroma_residue(source):
            course_slice_errors.append((source.name, "magenta chroma residue"))
        stage = source.stem.split("-")[-1]
        if stage not in FINAL_COURSE_STAGES:
            component_count = significant_alpha_component_count(source)
            if component_count != 1:
                course_slice_errors.append((source.name, "unexpected alpha components", component_count))
    for variety in sorted(PAPER_TREE_VARIETIES):
        for stage in sorted(PAPER_MATURE_STAGES):
            base_name = f"paper-{variety}-{stage}"
            paths = [stage_root / f"{base_name}.png"]
            paths.extend(sorted((ANIMATION_ROOT / base_name).glob("frame-*.png")))
            for source in paths:
                size, margin = alpha_margins(source)
                if margin is None or min(margin) < MIN_STAGE_SAFE_MARGIN_PX:
                    safe_margin_errors.append((str(source.relative_to(ROOT)), size, margin))

    print(f"stage safe-margin errors {len(safe_margin_errors)}")
    for item in safe_margin_errors:
        print(item)
    if safe_margin_errors:
        raise SystemExit(1)

    print(f"course flower slice errors {len(course_slice_errors)}")
    for item in course_slice_errors:
        print(item)
    if course_slice_errors:
        raise SystemExit(1)

    main_text = MAIN_SCRIPT.read_text(encoding="utf-8")
    runtime_guard_text = main_text
    for script in RULE_SCRIPTS:
        if script.exists():
            runtime_guard_text += "\n" + script.read_text(encoding="utf-8")
    audio_errors = []
    for import_path in REQUIRED_AUDIO_IMPORTS:
        if not import_path.exists():
            audio_errors.append((import_path, "missing import"))
            continue
        import_text = import_path.read_text(encoding="utf-8")
        if "edit/loop_mode=1" not in import_text:
            audio_errors.append((import_path, "loop disabled"))

    print(f"audio import errors {len(audio_errors)}")
    for item in audio_errors:
        print(item)
    if audio_errors:
        raise SystemExit(1)

    ui_sprite_errors = []
    for sprite_path in REQUIRED_UI_SPRITES:
        import_path = Path(str(sprite_path) + ".import")
        if not sprite_path.exists():
            ui_sprite_errors.append((sprite_path, "missing png"))
            continue
        if not import_path.exists():
            ui_sprite_errors.append((import_path, "missing import"))
        image = Image.open(sprite_path).convert("RGBA")
        if image.size != (128, 128):
            ui_sprite_errors.append((sprite_path, f"unexpected size {image.size}"))
        alpha = image.getchannel("A")
        if alpha.getbbox() is None:
            ui_sprite_errors.append((sprite_path, "empty alpha"))
        if any(alpha.getpixel(point) != 0 for point in [(0, 0), (127, 0), (0, 127), (127, 127)]):
            ui_sprite_errors.append((sprite_path, "opaque corner"))
    print(f"ui sprite errors {len(ui_sprite_errors)}")
    for item in ui_sprite_errors:
        print(item)
    if ui_sprite_errors:
        raise SystemExit(1)

    required_runtime_snippets = [
        "const LAYOUT_VERSION := 30",
        'const MAIN_BGM_STREAM := "res://assets/audio/garden_bgm_main_loop.wav"',
        'const DORMANT_BGM_STREAM := "res://assets/audio/garden_bgm_dormant_loop.wav"',
        "const BGM_VOLUME_DB := -6.0",
        "const DORMANT_BGM_VOLUME_DB := -8.0",
        'const SEED_SHOP_ICON_SPRITE := "res://assets/sprites/ui/seed-shop-gpt-v1.png"',
        'const SEED_LOCKED_ICON_SPRITE := "res://assets/sprites/ui/seed-locked-gpt-v1.png"',
        "const HARVESTED_PAGE_SIZE := 9",
        "const PLOT_GROUND_ANCHOR_Y := 0.90",
        "const PLANT_MAP_SCALE := 0.49",
        '"paper:seed": Vector2(54, 72)',
        '"paper:sapling": Vector2(78, 112)',
        '"paper:tree": Vector2(148, 184)',
        '"paper:flower": Vector2(148, 184)',
        '"paper:fruit": Vector2(148, 184)',
        '"course:seed": Vector2(42, 50)',
        '"course:seedling": Vector2(76, 94)',
        '"course:bud": Vector2(104, 128)',
        '"course:bloom": Vector2(104, 128)',
        '"course:blossom": Vector2(104, 128)',
        "_web_stage_sprite_path",
        "_paged_plots_for_zone",
        "_render_harvested_pager",
        "_on_move_plot_pressed",
        "_move_plot_in_current_zone",
        "_build_decor_action_panel",
        "_select_placed_decoration",
        "_move_decoration_to_slot",
        "_web_stage_file_path",
        "res://assets/sprites/web-normalized-stages/%s.png",
        "_add_empty_plot_guide(button, button_size)",
        '_add_button_texture(button, plot.get("sprite", ""), sprite_filter, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)',
        "_update_bottom_move_button",
        "_reset_plot_to_empty(empty_plot)",
        "func _plot_button_position(map_rect: Rect2, plot: Dictionary, button_size: Vector2) -> Vector2:",
        "original_bottom_y - button_size.y",
        "animated_stage_textures",
        "_apply_stage_animation",
        "_stage_animation_frames",
        "res://assets/sprites/stage-animations/paper-trees/%s",
    ]
    forbidden_runtime_snippets = [
        "DISTINCT_MAP_STAGES",
        "_map_stage_sprite_path",
        "_map_stage_file_path",
        "base = _plot_sprite_frame_size(plot, base)",
        "_add_contact_shadow(button, button_size, 0.34, 0.08, 0.89, 0.045)",
        "button.clip_contents = true",
    ]
    for snippet in required_runtime_snippets:
        if snippet not in runtime_guard_text:
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
