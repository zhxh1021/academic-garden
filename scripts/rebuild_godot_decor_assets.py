from pathlib import Path
import shutil

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path.home() / ".codex" / "generated_images" / "019e8e78-5e8c-74a3-93f4-e0cdf952d624" / "ig_0004c7a99d254180016a20616807c88191932d75ba712caa83.png"
ART_OUT = ROOT / "godot-prototype" / "assets" / "art" / "decoration-sheet-gpt-v3-source.png"
SPRITE_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "sprout" / "decor"

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

TARGET_SIZE = 96
GREEN_KEY = (0, 255, 102)

CROP_BOXES = [
    (0, 300, 245, 570),
    (245, 285, 510, 585),
    (545, 270, 730, 610),
    (740, 300, 980, 590),
    (990, 260, 1230, 620),
    (0, 655, 260, 980),
    (270, 625, 470, 985),
    (500, 665, 735, 1000),
    (745, 665, 985, 1000),
    (990, 685, 1235, 985),
]


def green_distance(pixel):
    red, green, blue, _alpha = pixel
    return abs(red - GREEN_KEY[0]) + abs(green - GREEN_KEY[1]) + abs(blue - GREEN_KEY[2])


def remove_green(image):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            red, green, blue, alpha = pixels[x, y]
            if green > 145 and green > red * 1.35 and green > blue * 1.25:
                distance = green_distance((red, green, blue, alpha))
                if distance < 260:
                    pixels[x, y] = (red, green, blue, 0)
                else:
                    pixels[x, y] = (red, green, blue, min(alpha, 90))
            elif green > 135 and green - red > 45 and green - blue > 35:
                pixels[x, y] = (red, green, blue, 0)
            elif green > 120 and green > red and green > blue:
                pixels[x, y] = (red, min(green, max(red, blue) + 24), blue, alpha)
    return rgba


def trim_alpha(image):
    bbox = image.getbbox()
    return image.crop(bbox) if bbox else image


def remove_tiny_islands(image, min_area=60):
    rgba = image.copy()
    pixels = rgba.load()
    width, height = rgba.size
    seen = set()
    for y in range(height):
        for x in range(width):
            if (x, y) in seen or pixels[x, y][3] == 0:
                continue
            stack = [(x, y)]
            component = []
            seen.add((x, y))
            while stack:
                current_x, current_y = stack.pop()
                component.append((current_x, current_y))
                for next_x, next_y in (
                    (current_x + 1, current_y),
                    (current_x - 1, current_y),
                    (current_x, current_y + 1),
                    (current_x, current_y - 1),
                ):
                    if next_x < 0 or next_x >= width or next_y < 0 or next_y >= height:
                        continue
                    if (next_x, next_y) in seen or pixels[next_x, next_y][3] == 0:
                        continue
                    seen.add((next_x, next_y))
                    stack.append((next_x, next_y))
            xs = [point[0] for point in component]
            ys = [point[1] for point in component]
            component_width = max(xs) - min(xs) + 1
            component_height = max(ys) - min(ys) + 1
            is_thin_fragment = component_width <= 8 and component_height >= 18
            if len(component) < min_area or is_thin_fragment:
                for pixel_x, pixel_y in component:
                    pixels[pixel_x, pixel_y] = (0, 0, 0, 0)
    return rgba


def fit_to_square(image):
    trimmed = trim_alpha(remove_tiny_islands(image))
    target = Image.new("RGBA", (TARGET_SIZE, TARGET_SIZE), (0, 0, 0, 0))
    max_edge = TARGET_SIZE - 8
    scale = min(max_edge / trimmed.width, max_edge / trimmed.height)
    new_size = (max(1, round(trimmed.width * scale)), max(1, round(trimmed.height * scale)))
    resized = trimmed.resize(new_size, Image.Resampling.LANCZOS)
    offset = ((TARGET_SIZE - new_size[0]) // 2, TARGET_SIZE - new_size[1] - 4)
    target.alpha_composite(resized, offset)
    return target


def main():
    if not SOURCE.exists():
        raise FileNotFoundError(SOURCE)

    ART_OUT.parent.mkdir(parents=True, exist_ok=True)
    SPRITE_DIR.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SOURCE, ART_OUT)

    sheet = Image.open(SOURCE).convert("RGBA")
    for index, filename in enumerate(ITEMS):
        cell = sheet.crop(CROP_BOXES[index])
        sprite = fit_to_square(remove_green(cell))
        sprite.save(SPRITE_DIR / filename)


if __name__ == "__main__":
    main()
