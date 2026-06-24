import json
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-prototype"
SEED = GODOT / "data" / "garden_seed.json"
OUT = GODOT / "assets" / "art" / "godot-web-assets-active-preview.png"
PREVIEW_DIR = GODOT / "assets" / "art"

CANVAS = (780, 1240)
MAP_ASPECT = CANVAS[0] / CANVAS[1]
HARVESTED_PAGE_SIZE = 9
STAGE_SIZES = {
    ("paper", "seed"): (54, 72),
    ("paper", "sapling"): (78, 112),
    ("paper", "tree"): (148, 184),
    ("paper", "flower"): (148, 184),
    ("paper", "fruit"): (148, 184),
    ("course", "seed"): (42, 50),
    ("course", "seedling"): (76, 94),
    ("course", "bud"): (104, 128),
    ("course", "bloom"): (104, 128),
    ("course", "blossom"): (104, 128),
}
EMPTY_SIZE = (72, 72)
DECOR_SIZE = (78, 78)
PLOT_GROUND_ANCHOR_Y = 0.90
PLANT_MAP_SCALE = 0.49


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


def stretch_sprite(image, size):
    return image.convert("RGBA").resize(size, Image.Resampling.NEAREST)


def draw_empty_plot_guide(canvas, x, y, size):
    width = round(size[0] * 0.70)
    height = round(size[1] * 0.42)
    left = round(x + (size[0] - width) * 0.5)
    top = round(y + size[1] * 0.54)
    draw = ImageDraw.Draw(canvas)
    color = (255, 240, 165, 220)
    plus = (255, 247, 189, 142)
    dash = 7
    gap = 5
    for px in range(left, left + width, dash + gap):
        draw.line((px, top, min(px + dash, left + width), top), fill=color, width=2)
        draw.line((px, top + height, min(px + dash, left + width), top + height), fill=color, width=2)
    for py in range(top, top + height, dash + gap):
        draw.line((left, py, left, min(py + dash, top + height)), fill=color, width=2)
        draw.line((left + width, py, left + width, min(py + dash, top + height)), fill=color, width=2)
    cx = left + width // 2
    cy = top + height // 2
    draw.line((cx - 8, cy, cx + 8, cy), fill=plus, width=2)
    draw.line((cx, cy - 8, cx, cy + 8), fill=plus, width=2)


def render_zone(zone, decor_catalog):
    canvas = cover_to_canvas(Image.open(res(zone["map"])))

    layers = []
    plots = zone["plots"]
    if zone.get("id") == "harvested":
        plots = plots[:HARVESTED_PAGE_SIZE]
    for plot in plots:
        base_size = STAGE_SIZES.get((plot.get("kind"), plot.get("stage")), EMPTY_SIZE)
        layers.append(("plot", plot, base_size))
    for placed in zone.get("decorations", []):
        decor = decor_catalog.get(placed.get("id"))
        if decor:
            layers.append(("decor", {**placed, "sprite": decor["sprite"]}, DECOR_SIZE))

    layers.sort(key=lambda item: (float(item[1].get("y", 0.5)), float(item[1].get("x", 0.5))))
    for kind, item, base_size in layers:
        scale = float(item.get("size_scale", 1.0))
        is_empty_plot = kind == "plot" and item.get("kind") == "empty"
        is_plant = kind == "plot" and not is_empty_plot
        sprite_image = None
        if not is_empty_plot:
            sprite_image = Image.open(res(item["sprite"]))
        frame_size = base_size
        item_scale = scale * (PLANT_MAP_SCALE if is_plant else 1.0)
        size = (round(frame_size[0] * item_scale), round(frame_size[1] * item_scale))
        anchor = (item["x"] * CANVAS[0], item["y"] * CANVAS[1])
        base_x = round(anchor[0] - size[0] * 0.5)
        original_height = round(frame_size[1] * scale)
        original_bottom_y = anchor[1] + original_height * (1.0 - PLOT_GROUND_ANCHOR_Y)
        base_y = round(original_bottom_y - size[1])
        if is_empty_plot:
            draw_empty_plot_guide(canvas, base_x, base_y, size)
            continue
        sprite = stretch_sprite(sprite_image, size) if is_plant else fit_sprite(sprite_image, size)
        x = round(base_x + (size[0] - sprite.width) * 0.5)
        y = round(base_y + (size[1] - sprite.height))
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
