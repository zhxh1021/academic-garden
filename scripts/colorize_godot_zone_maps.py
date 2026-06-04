from pathlib import Path

from PIL import Image, ImageEnhance


ROOT = Path(__file__).resolve().parents[1]
MAP_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "maps"


def tint_image(src: Path, dst: Path, tint: tuple[int, int, int], *, brightness: float, contrast: float, saturation: float) -> None:
    image = Image.open(src).convert("RGBA")
    base = ImageEnhance.Color(image).enhance(saturation)
    base = ImageEnhance.Contrast(base).enhance(contrast)
    base = ImageEnhance.Brightness(base).enhance(brightness)

    overlay = Image.new("RGBA", base.size, (*tint, 255))
    tinted = Image.blend(base, overlay, 0.24)
    tinted.putalpha(image.getchannel("A"))
    tinted.save(dst)


def main() -> None:
    tint_image(
        MAP_DIR / "sprout-map-harvested-gpt-v4-noplot-tallfield.png",
        MAP_DIR / "sprout-map-harvested-gpt-v4-noplot-tallfield-warm.png",
        (255, 196, 67),
        brightness=1.08,
        contrast=1.04,
        saturation=1.22,
    )
    tint_image(
        MAP_DIR / "sprout-map-dormant-gpt-v4-noplot-tallfield.png",
        MAP_DIR / "sprout-map-dormant-gpt-v4-noplot-tallfield-night.png",
        (38, 66, 124),
        brightness=0.62,
        contrast=0.96,
        saturation=0.78,
    )
    print("wrote harvested warm and dormant night map variants")


if __name__ == "__main__":
    main()
