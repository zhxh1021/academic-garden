import json
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-prototype"
SEED = GODOT / "data" / "garden_seed.json"
OUT = GODOT / "assets" / "art" / "godot-web-assets-active-preview.png"
PREVIEW_DIR = GODOT / "assets" / "art"

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
DECOR_SIZE = (78, 78)


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


def render_zone(zone, decor_catalog):
    canvas = cover_to_canvas(Image.open(res(zone["map"])))

    layers = []
    for plot in zone["plots"]:
        base_size = STAGE_SIZES.get((plot.get("kind"), plot.get("stage")), EMPTY_SIZE)
        layers.append(("plot", plot, base_size))
    for placed in zone.get("decorations", []):
        decor = decor_catalog.get(placed.get("id"))
        if decor:
            layers.append(("decor", {**placed, "sprite": decor["sprite"]}, DECOR_SIZE))

    layers.sort(key=lambda item: (float(item[1].get("y", 0.5)), float(item[1].get("x", 0.5))))
    for kind, item, base_size in layers:
        scale = float(item.get("size_scale", 1.0))
        size = (round(base_size[0] * scale), round(base_size[1] * scale))
        sprite = fit_sprite(Image.open(res(item["sprite"])), size)
        anchor = (item["x"] * CANVAS[0], item["y"] * CANVAS[1])
        x = round(anchor[0] - size[0] * 0.5 + (size[0] - sprite.width) * 0.5)
        y = round(anchor[1] - size[1] * 0.82 + (size[1] - sprite.height))
        canvas.alpha_composite(sprite, (x, y))
    return canvas


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    decor_catalog = {item["id"]: item for item in data["decoration_catalog"]}
    previews = []
    PREVIEW_DIR.mkdir(parents=True, exist_ok=True)
    for zone in data["zones"]:
        canvas = render_zone(zone, decor_catalog)
        path = PREVIEW_DIR / f"godot-web-assets-{zone['id']}-preview.png"
        canvas.save(path)
        previews.append(canvas)
        print(path)

    contact = Image.new("RGBA", (CANVAS[0] * len(previews), CANVAS[1]), (0, 0, 0, 255))
    for index, image in enumerate(previews):
        contact.alpha_composite(image, (CANVAS[0] * index, 0))
    contact.save(PREVIEW_DIR / "godot-web-assets-zone-preview-contact.png")
    previews[0].save(OUT)
    print(PREVIEW_DIR / "godot-web-assets-zone-preview-contact.png")


if __name__ == "__main__":
    main()
