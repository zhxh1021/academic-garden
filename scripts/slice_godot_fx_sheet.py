from pathlib import Path

from PIL import Image, ImageDraw, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "godot-prototype" / "assets" / "art" / "garden-fx-sheet-gpt-v1-source.png"
OUT_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "fx"
CONTACT = ROOT / "godot-prototype" / "assets" / "art" / "garden-fx-sheet-gpt-v1-contact.png"

SPRITES = [
    "fx-paper-sparkle.png",
    "fx-course-petal.png",
    "fx-dormant-moon.png",
    "fx-harvest-leaf.png",
    "fx-placement-ring.png",
    "fx-water-burst.png",
    "fx-lantern-twinkle.png",
    "fx-seed-puff.png",
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
	cell_w = source.width // 4
	cell_h = source.height // 2
	contact = Image.new("RGBA", (4 * 144, 2 * 124), (24, 33, 28, 255))
	draw = ImageDraw.Draw(contact)
	for index, name in enumerate(SPRITES):
		col = index % 4
		row = index // 4
		crop = source.crop((col * cell_w, row * cell_h, (col + 1) * cell_w, (row + 1) * cell_h))
		sprite = trim(crop)
		sprite.save(OUT_DIR / name)
		preview = ImageOps.contain(sprite, (84, 84), Image.Resampling.NEAREST)
		px = col * 144 + (144 - preview.width) // 2
		py = row * 124 + 8 + (84 - preview.height) // 2
		contact.alpha_composite(preview, (px, py))
		draw.text((col * 144 + 8, row * 124 + 98), name.removesuffix(".png"), fill=(236, 232, 198, 255))
		print(OUT_DIR / name)
	contact.save(CONTACT)
	print(CONTACT)


if __name__ == "__main__":
    main()
