from __future__ import annotations

import json
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-prototype"
SOURCE = GODOT / "assets" / "sprites" / "stages"
OUTPUT = GODOT / "assets" / "sprites" / "web-normalized-stages"
SEED = GODOT / "data" / "garden_seed.json"

STAGE_FLOW = {
    "paper": ["seed", "sapling", "tree", "flower", "fruit"],
    "course": ["sowing", "growing", "bloom", "fruit", "seed_saved"],
}


def plant_base(plot):
    name = Path(plot["sprite"]).stem
    for suffix in ("-rebuilt", "-portrait", "-full"):
        if name.endswith(suffix):
            name = name.removesuffix(suffix)
    stage = plot["stage"]
    marker = f"-{stage}"
    if marker in name:
        return name.split(marker, 1)[0]
    for candidate in STAGE_FLOW[plot["kind"]]:
        marker = f"-{candidate}"
        if name.endswith(marker):
            return name.removesuffix(marker)
    return name


def source_for(base: str, stage: str) -> Path:
    full = SOURCE / f"{base}-{stage}-full.png"
    if full.exists():
        return full
    return SOURCE / f"{base}-{stage}.png"


def clean_connected_key_color(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = image.load()
    width, height = image.size
    stack = [(x, 0) for x in range(width)] + [(x, height - 1) for x in range(width)]
    stack += [(0, y) for y in range(height)] + [(width - 1, y) for y in range(height)]
    seen = set()

    def is_key(x: int, y: int) -> bool:
        r, g, b, a = pixels[x, y]
        return a > 0 and r > 145 and g < 125 and b > 125

    while stack:
        x, y = stack.pop()
        if x < 0 or x >= width or y < 0 or y >= height or (x, y) in seen:
            continue
        seen.add((x, y))
        if not is_key(x, y):
            continue
        r, g, b, _a = pixels[x, y]
        pixels[x, y] = (r, g, b, 0)
        stack.extend(((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)))
    return image


def largest_component_bbox(image: Image.Image):
    alpha = image.getchannel("A")
    width, height = image.size
    pix = alpha.load()
    seen = set()
    best = None
    best_count = 0
    for y in range(height):
        for x in range(width):
            if pix[x, y] == 0 or (x, y) in seen:
                continue
            stack = [(x, y)]
            seen.add((x, y))
            count = 0
            min_x = max_x = x
            min_y = max_y = y
            while stack:
                cx, cy = stack.pop()
                count += 1
                min_x = min(min_x, cx)
                max_x = max(max_x, cx)
                min_y = min(min_y, cy)
                max_y = max(max_y, cy)
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < width and 0 <= ny < height and (nx, ny) not in seen and pix[nx, ny] > 0:
                        seen.add((nx, ny))
                        stack.append((nx, ny))
            if count > best_count:
                best_count = count
                best = (min_x, min_y, max_x + 1, max_y + 1)
    return best


def normalize(path: Path, kind: str) -> Image.Image:
    image = clean_connected_key_color(Image.open(path))
    bbox = largest_component_bbox(image) or image.getbbox()
    if bbox is None:
        return Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    sprite = image.crop(bbox)
    pad_x = 8 if kind == "paper" else 7
    pad_top = 8
    pad_bottom = 8
    canvas_size = (sprite.width + pad_x * 2, sprite.height + pad_top + pad_bottom)
    canvas = Image.new("RGBA", canvas_size, (0, 0, 0, 0))
    canvas.alpha_composite(sprite, (pad_x, pad_top))
    return canvas


def discover_all_stage_sources() -> list[tuple[str, str, str, Path]]:
    discovered = {}
    for path in SOURCE.glob("*.png"):
        stem = path.stem.removesuffix("-full")
        for kind, stages in STAGE_FLOW.items():
            if not stem.startswith(f"{kind}-"):
                continue
            for stage in stages:
                marker = f"-{stage}"
                if stem.endswith(marker):
                    base = stem.removesuffix(marker)
                    key = (kind, base, stage)
                    current = discovered.get(key)
                    if current is None or path.stem.endswith("-full"):
                        discovered[key] = path
                    break
    return [(kind, base, stage, path) for (kind, base, stage), path in sorted(discovered.items())]


def main() -> None:
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for kind, base, stage, source in discover_all_stage_sources():
        name = f"{base}-{stage}.png"
        normalized = normalize(source, kind)
        normalized.save(OUTPUT / name)
        print(f"{name} <- {source.name}")


if __name__ == "__main__":
    main()
