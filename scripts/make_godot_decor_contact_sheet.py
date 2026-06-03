from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SPRITE_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "decor"
OUT = ROOT / "godot-prototype" / "assets" / "art" / "decoration-sheet-gpt-v3-contact.png"

ITEMS = [
    "decor-stone-path.png",
    "decor-wood-bench.png",
    "decor-lamp.png",
    "decor-pond.png",
    "decor-well.png",
    "decor-workbench.png",
    "decor-sign.png",
    "decor-flower-rock.png",
    "decor-wood-bridge.png",
    "decor-picnic-rug.png",
]


def main():
    sheet = Image.new("RGBA", (5 * 120, 2 * 120), (216, 232, 185, 255))
    for index, filename in enumerate(ITEMS):
        image = Image.open(SPRITE_DIR / filename).convert("RGBA")
        x = (index % 5) * 120 + 12
        y = (index // 5) * 120 + 12
        sheet.alpha_composite(image, (x, y))
    OUT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(OUT)


if __name__ == "__main__":
    main()
