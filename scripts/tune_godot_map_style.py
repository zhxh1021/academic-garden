from pathlib import Path

from PIL import Image, ImageEnhance, ImageFilter, ImageOps


ROOT = Path(__file__).resolve().parents[1]
MAP_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "maps"
ART_DIR = ROOT / "godot-prototype" / "assets" / "art"

MAPS = {
    "active": MAP_DIR / "sprout-map-active-gpt-v4.png",
    "harvested": MAP_DIR / "sprout-map-harvested-gpt-v4.png",
    "dormant": MAP_DIR / "sprout-map-dormant-gpt-v4.png",
}


def pixel_match_map(source: Image.Image) -> Image.Image:
    image = source.convert("RGBA")
    working_size = (390, 620)
    image = image.resize(working_size, Image.Resampling.BICUBIC)
    image = ImageEnhance.Color(image).enhance(0.90)
    image = ImageEnhance.Contrast(image).enhance(0.92)
    image = ImageEnhance.Brightness(image).enhance(0.96)

    cream = Image.new("RGBA", image.size, "#e8d1a0")
    image = Image.blend(image, cream, 0.10)

    rgb = image.convert("RGB")
    rgb = ImageOps.posterize(rgb, 5)
    image = rgb.convert("RGBA")

    image = image.resize(source.size, Image.Resampling.NEAREST)

    # A very soft paper-toned veil keeps the high-detail map behind the
    # lower-resolution Sprout sprites instead of competing with them.
    veil = Image.new("RGBA", source.size, "#f0dfb8")
    image = Image.blend(image, veil, 0.045)
    return image


def contact_sheet(outputs: dict[str, Image.Image]) -> None:
    ART_DIR.mkdir(parents=True, exist_ok=True)
    thumb_size = (195, 310)
    sheet = Image.new("RGB", (thumb_size[0] * 2 * len(outputs), thumb_size[1]), "#f3ead2")
    for index, (zone, output) in enumerate(outputs.items()):
        before = Image.open(MAPS[zone]).convert("RGB").resize(thumb_size, Image.Resampling.LANCZOS)
        after = output.convert("RGB").resize(thumb_size, Image.Resampling.NEAREST)
        sheet.paste(before, (index * thumb_size[0] * 2, 0))
        sheet.paste(after, (index * thumb_size[0] * 2 + thumb_size[0], 0))
    sheet.save(ART_DIR / "godot-map-style-v5-contact-sheet.png")


def main() -> None:
    outputs = {}
    for zone, path in MAPS.items():
        source = Image.open(path)
        output = pixel_match_map(source)
        output_path = MAP_DIR / f"sprout-map-{zone}-gpt-v5.png"
        output.save(output_path)
        outputs[zone] = output
        print(f"wrote {output_path.relative_to(ROOT)}")
    contact_sheet(outputs)
    print("wrote godot-prototype/assets/art/godot-map-style-v5-contact-sheet.png")


if __name__ == "__main__":
    main()
