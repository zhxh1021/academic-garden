from __future__ import annotations

from pathlib import Path
import random

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
MAP_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "maps"

def remove_plots(path: Path) -> None:
    image = Image.open(path).convert("RGBA")
    zone = path.name.removeprefix("sprout-map-").removesuffix("-gpt-v5.png")
    empty_path = MAP_DIR / f"sprout-map-{zone}-gpt-v3-empty.png"
    if not empty_path.exists():
        empty_path = MAP_DIR / "sprout-map-active-gpt-v3-empty.png"

    empty = Image.open(empty_path).convert("RGBA")
    grass = empty.crop((390, 210, 1160, 820)).resize((600, 420), Image.Resampling.LANCZOS)
    # V5 is warmer and softer than the empty source. A mild blur lets it sit under
    # the foreground without looking like a hard pasted rectangle.
    grass = grass.filter(ImageFilter.GaussianBlur(0.35))
    grass = ImageEnhance.Brightness(grass).enhance(0.82)
    grass = ImageEnhance.Color(grass).enhance(0.82)

    result = image.copy()
    x, y = 90, 450
    mask = Image.new("L", grass.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((18, 16, grass.width - 18, grass.height - 18), radius=92, fill=238)
    mask = mask.filter(ImageFilter.GaussianBlur(20))

    base_crop = result.crop((x, y, x + grass.width, y + grass.height))
    blended = Image.composite(grass, base_crop, mask)
    result.paste(blended, (x, y))

    output = path.with_name(path.stem + "-noplot.png")
    result.save(output)
    print(output)


def main() -> None:
    for zone in ("active", "harvested", "dormant"):
        remove_plots(MAP_DIR / f"sprout-map-{zone}-gpt-v5.png")


if __name__ == "__main__":
    main()
