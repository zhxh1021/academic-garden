from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
MAP_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "maps"

SOURCE_TOP = 360
SOURCE_FIELD_BOTTOM = 890
TARGET_FIELD_BOTTOM = 995


def remove_plots(image: Image.Image, zone: str) -> Image.Image:
    empty_path = MAP_DIR / f"sprout-map-{zone}-gpt-v3-empty.png"
    if not empty_path.exists():
        empty_path = MAP_DIR / "sprout-map-active-gpt-v3-empty.png"

    empty = Image.open(empty_path).convert("RGBA")
    grass = empty.crop((390, 210, 1160, 820)).resize((600, 420), Image.Resampling.LANCZOS)
    grass = grass.filter(ImageFilter.GaussianBlur(0.25))

    result = image.copy()
    x, y = 90, 450
    mask = Image.new("L", grass.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((18, 16, grass.width - 18, grass.height - 18), radius=92, fill=238)
    mask = mask.filter(ImageFilter.GaussianBlur(20))

    base_crop = result.crop((x, y, x + grass.width, y + grass.height))
    blended = Image.composite(grass, base_crop, mask)
    result.paste(blended, (x, y))
    return result


def stretch_field(image: Image.Image) -> Image.Image:
    result = Image.new("RGBA", image.size)

    width, height = image.size
    result.paste(image.crop((0, 0, width, SOURCE_TOP)), (0, 0))

    field = image.crop((0, SOURCE_TOP, width, SOURCE_FIELD_BOTTOM))
    field = field.resize((width, TARGET_FIELD_BOTTOM - SOURCE_TOP), Image.Resampling.LANCZOS)
    result.paste(field, (0, SOURCE_TOP))

    lower = image.crop((0, SOURCE_FIELD_BOTTOM, width, height))
    lower = lower.resize((width, height - TARGET_FIELD_BOTTOM), Image.Resampling.LANCZOS)
    result.paste(lower, (0, TARGET_FIELD_BOTTOM))
    return result


def build_map(path: Path) -> None:
    zone = path.name.removeprefix("sprout-map-").removesuffix("-gpt-v4.png")
    image = Image.open(path).convert("RGBA")
    result = stretch_field(remove_plots(image, zone))
    output = path.with_name(path.stem + "-noplot-tallfield.png")
    result.save(output)
    print(output)


def main() -> None:
    for zone in ("active", "harvested", "dormant"):
        build_map(MAP_DIR / f"sprout-map-{zone}-gpt-v4.png")


if __name__ == "__main__":
    main()
