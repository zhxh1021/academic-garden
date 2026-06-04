from pathlib import Path

from PIL import Image, ImageDraw, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "godot-prototype" / "assets" / "art" / "care-ui-icons-gpt-v1-source.png"
OUT_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "ui"
CONTACT = ROOT / "godot-prototype" / "assets" / "art" / "care-ui-icons-gpt-v1-contact.png"

SPRITES = [
    "care-sun-gpt-v1.png",
    "care-water-gpt-v1.png",
    "care-fertilizer-gpt-v1.png",
    "care-record-gpt-v1.png",
    "care-coin-gpt-v1.png",
    "care-seed-packet-gpt-v1.png",
]

KEY = (255, 0, 255)


def key_to_alpha(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            distance = abs(r - KEY[0]) + abs(g - KEY[1]) + abs(b - KEY[2])
            if distance < 72:
                pixels[x, y] = (r, g, b, 0)
            elif r > 210 and b > 210 and g < 80:
                pixels[x, y] = (r, g, b, min(a, 80))
    return image


def trim(sprite: Image.Image, padding: int = 10) -> Image.Image:
    alpha = sprite.getchannel("A")
    box = alpha.getbbox()
    if box is None:
        return sprite
    left = max(0, box[0] - padding)
    top = max(0, box[1] - padding)
    right = min(sprite.width, box[2] + padding)
    bottom = min(sprite.height, box[3] + padding)
    return sprite.crop((left, top, right, bottom))


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    source = key_to_alpha(Image.open(SOURCE))
    cell_w = source.width // 3
    cell_h = source.height // 2
    contact = Image.new("RGBA", (3 * 160, 2 * 132), (24, 33, 28, 255))
    draw = ImageDraw.Draw(contact)
    for index, name in enumerate(SPRITES):
        col = index % 3
        row = index // 3
        crop = source.crop((col * cell_w, row * cell_h, (col + 1) * cell_w, (row + 1) * cell_h))
        sprite = trim(crop)
        sprite.save(OUT_DIR / name)
        preview = ImageOps.contain(sprite, (86, 86), Image.Resampling.NEAREST)
        px = col * 160 + (160 - preview.width) // 2
        py = row * 132 + 8 + (86 - preview.height) // 2
        contact.alpha_composite(preview, (px, py))
        draw.text((col * 160 + 8, row * 132 + 106), name.removesuffix(".png"), fill=(236, 232, 198, 255))
        print(OUT_DIR / name)
    contact.save(CONTACT)
    print(CONTACT)


if __name__ == "__main__":
    main()
