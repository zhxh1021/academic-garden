import json
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-prototype"
SEED = GODOT / "data" / "garden_seed.json"
OUT = GODOT / "assets" / "art" / "godot-web-assets-active-preview.png"

CANVAS = (780, 1240)
MAP_ASPECT = CANVAS[0] / CANVAS[1]
STAGE_SIZES = {
    ("paper", "seed"): (52, 56),
    ("paper", "sapling"): (68, 88),
    ("paper", "tree"): (116, 138),
    ("paper", "flower"): (116, 138),
    ("paper", "fruit"): (116, 138),
    ("course", "sowing"): (50, 56),
    ("course", "growing"): (82, 102),
    ("course", "bloom"): (92, 112),
    ("course", "fruit"): (92, 112),
    ("course", "seed_saved"): (92, 112),
}
EMPTY_SIZE = (72, 72)


def res(path):
    return GODOT / path.removeprefix("res://")


def cover_to_canvas(image):
    src_aspect = image.width / image.height
    if src_aspect > MAP_ASPECT:
        new_h = CANVAS[1]
        new_w = round(new_h * src_aspect)
    else:
        new_w = CANVAS[0]
        new_h = round(new_w / src_aspect)
    resized = image.resize((new_w, new_h), Image.Resampling.LANCZOS)
    left = (new_w - CANVAS[0]) // 2
    top = (new_h - CANVAS[1]) // 2
    return resized.crop((left, top, left + CANVAS[0], top + CANVAS[1])).convert("RGBA")


def fit_sprite(image, size):
    image = image.convert("RGBA")
    scale = min(size[0] / image.width, size[1] / image.height)
    new_size = (max(1, round(image.width * scale)), max(1, round(image.height * scale)))
    return image.resize(new_size, Image.Resampling.LANCZOS)


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    zone = next(item for item in data["zones"] if item["id"] == "active")
    canvas = cover_to_canvas(Image.open(res(zone["map"])))

    plots = sorted(zone["plots"], key=lambda item: (float(item.get("y", 0.5)), float(item.get("x", 0.5))))
    for plot in plots:
        base_size = STAGE_SIZES.get((plot.get("kind"), plot.get("stage")), EMPTY_SIZE)
        scale = float(plot.get("size_scale", 1.0))
        size = (round(base_size[0] * scale), round(base_size[1] * scale))
        sprite = fit_sprite(Image.open(res(plot["sprite"])), size)
        anchor = (plot["x"] * CANVAS[0], plot["y"] * CANVAS[1])
        x = round(anchor[0] - size[0] * 0.5 + (size[0] - sprite.width) * 0.5)
        y = round(anchor[1] - size[1] * 0.82 + (size[1] - sprite.height))
        canvas.alpha_composite(sprite, (x, y))

    OUT.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(OUT)
    print(OUT)


if __name__ == "__main__":
    main()
