from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SPRITE_ROOT = ROOT / "godot-prototype" / "assets" / "sprites"
STAGE_DIR = SPRITE_ROOT / "stages"
NORMALIZED_DIR = SPRITE_ROOT / "web-normalized-stages"
ART_DIR = ROOT / "godot-prototype" / "assets" / "art"
SOURCE = ART_DIR / "paper-tree-flower-fruit-imagegen-v1-source.png"
CONTACT = ART_DIR / "tree-stage-contact-sheet-imagegen-flower-fruit-v1.png"

VARIETIES = [
    ("paper-ginkgo", "Ginkgo", (235, 278)),
    ("paper-cherry", "Cherry", (256, 278)),
    ("paper-maple", "Maple", (230, 272)),
    ("paper-pine", "Pine", (198, 293)),
    ("paper-willow", "Willow", (215, 274)),
    ("paper-camphor", "Camphor", (241, 279)),
]
STAGES = [("flower", "Flower"), ("fruit", "Fruit")]


def _font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        Path("C:/Windows/Fonts/arialbd.ttf") if bold else Path("C:/Windows/Fonts/arial.ttf"),
        Path("C:/Windows/Fonts/calibrib.ttf") if bold else Path("C:/Windows/Fonts/calibri.ttf"),
    ]
    for path in candidates:
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def _is_checker_pixel(pixel: tuple[int, int, int, int]) -> bool:
    r, g, b, a = pixel
    return a > 0 and min(r, g, b) > 218 and max(r, g, b) - min(r, g, b) < 16


def _remove_border_checkerboard(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    seen = set()
    queue: deque[tuple[int, int]] = deque()

    for x in range(width):
        queue.append((x, 0))
        queue.append((x, height - 1))
    for y in range(height):
        queue.append((0, y))
        queue.append((width - 1, y))

    while queue:
        x, y = queue.popleft()
        if (x, y) in seen or x < 0 or y < 0 or x >= width or y >= height:
            continue
        seen.add((x, y))
        if not _is_checker_pixel(pixels[x, y]):
            continue
        pixels[x, y] = (255, 255, 255, 0)
        queue.extend(((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)))

    return rgba


def _remove_upper_row_fragments(image: Image.Image) -> Image.Image:
    rgba = image.copy()
    pixels = rgba.load()
    width, height = rgba.size
    seen = set()
    components: list[tuple[int, tuple[int, int, int, int], list[tuple[int, int]]]] = []

    for y in range(height):
        for x in range(width):
            if (x, y) in seen or pixels[x, y][3] == 0:
                continue
            queue: deque[tuple[int, int]] = deque([(x, y)])
            seen.add((x, y))
            coords: list[tuple[int, int]] = []
            while queue:
                px, py = queue.popleft()
                coords.append((px, py))
                for nx, ny in ((px - 1, py), (px + 1, py), (px, py - 1), (px, py + 1)):
                    if 0 <= nx < width and 0 <= ny < height and (nx, ny) not in seen and pixels[nx, ny][3] > 0:
                        seen.add((nx, ny))
                        queue.append((nx, ny))
            xs = [coord[0] for coord in coords]
            ys = [coord[1] for coord in coords]
            components.append((len(coords), (min(xs), min(ys), max(xs) + 1, max(ys) + 1), coords))

    if not components:
        return rgba
    largest = max(components, key=lambda item: item[0])
    largest_top = largest[1][1]
    for _area, box, coords in components:
        if box == largest[1]:
            continue
        touches_top = box[1] == 0
        ends_before_subject = box[3] <= largest_top + 5
        if touches_top and ends_before_subject:
            for px, py in coords:
                pixels[px, py] = (255, 255, 255, 0)
    return rgba


def _fit_to_canvas(sprite: Image.Image, size: tuple[int, int]) -> Image.Image:
    bbox = sprite.getchannel("A").getbbox()
    if bbox is None:
        return Image.new("RGBA", size, (255, 255, 255, 0))
    trimmed = sprite.crop(bbox)
    fitted = ImageOps.contain(trimmed, (size[0] - 8, size[1] - 8), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", size, (255, 255, 255, 0))
    canvas.alpha_composite(fitted, ((size[0] - fitted.width) // 2, size[1] - fitted.height - 8))
    return canvas


def slice_sprites() -> None:
    source = Image.open(SOURCE).convert("RGBA")
    cell_width = source.width // 2
    cell_height = source.height // 6
    for row, (base, _label, target_size) in enumerate(VARIETIES):
        for col, (stage, _stage_label) in enumerate(STAGES):
            cell = source.crop((col * cell_width, row * cell_height, (col + 1) * cell_width, (row + 1) * cell_height))
            transparent = _remove_upper_row_fragments(_remove_border_checkerboard(cell))
            fitted = _fit_to_canvas(transparent, target_size)
            fitted.save(STAGE_DIR / f"{base}-{stage}-full.png")
            fitted.save(NORMALIZED_DIR / f"{base}-{stage}.png")


def make_contact_sheet() -> None:
    font_title = _font(36, True)
    font_head = _font(23, True)
    font_label = _font(18, True)
    font_small = _font(13)
    stages = [("seed", "Seed"), ("sapling", "Sapling"), ("tree", "Mature"), ("flower", "Flower"), ("fruit", "Fruit")]
    cell_w, cell_h = 230, 246
    left_w, top_h = 90, 88
    margin = 30
    sheet_w = margin * 2 + left_w + cell_w * len(stages)
    sheet_h = margin * 2 + top_h + cell_h * len(VARIETIES)
    sheet = Image.new("RGBA", (sheet_w, sheet_h), "#f5eddc")
    draw = ImageDraw.Draw(sheet)
    draw.text((margin, 20), "ImageGen Paper Tree Flower/Fruit Sprites - Numbered Review Sheet", font=font_title, fill="#332719")
    draw.text((margin, 62), "Right two columns are generated with ImageGen and sliced into runtime sprites.", font=font_small, fill="#6a5a42")
    for col, (_stage, label) in enumerate(stages):
        x = margin + left_w + col * cell_w
        bbox = draw.textbbox((0, 0), label, font=font_head)
        draw.text((x + (cell_w - (bbox[2] - bbox[0])) // 2, margin + 50), label, font=font_head, fill="#4a3823")

    number = 1
    for row, (base, variety_label, _target_size) in enumerate(VARIETIES):
        y = margin + top_h + row * cell_h
        draw.text((margin, y + 34), variety_label, font=font_head, fill="#2f2a20")
        draw.text((margin, y + 66), base.replace("paper-", ""), font=font_small, fill="#6f6048")
        for col, (stage, stage_label) in enumerate(stages):
            x = margin + left_w + col * cell_w
            if stage in {"tree", "flower", "fruit"}:
                path = STAGE_DIR / f"{base}-{stage}-full.png"
            else:
                path = NORMALIZED_DIR / f"{base}-{stage}.png"
            sprite = Image.open(path).convert("RGBA")
            fitted = ImageOps.contain(sprite, (170, 166), Image.Resampling.NEAREST)
            tile = Image.new("RGBA", (cell_w - 16, cell_h - 18), "#fbf6ea")
            tile_draw = ImageDraw.Draw(tile)
            tile_draw.rounded_rectangle((0, 0, tile.width - 1, tile.height - 1), radius=8, fill="#fbf6ea", outline="#c6aa78", width=2)
            tile.alpha_composite(fitted, ((tile.width - fitted.width) // 2, 172 - fitted.height + 8))
            label = f"#{number:02d} {variety_label} {stage_label}"
            bbox = tile_draw.textbbox((0, 0), label, font=font_label)
            tile_draw.text(((tile.width - (bbox[2] - bbox[0])) // 2, 184), label, font=font_label, fill="#2b261f")
            file_label = path.name
            bbox = tile_draw.textbbox((0, 0), file_label, font=font_small)
            tile_draw.text(((tile.width - (bbox[2] - bbox[0])) // 2, 211), file_label, font=font_small, fill="#6a5a42")
            sheet.alpha_composite(tile, (x + 5, y + 4))
            number += 1
    sheet.convert("RGB").save(CONTACT, quality=95)


def main() -> None:
    slice_sprites()
    make_contact_sheet()
    print(CONTACT.resolve())


if __name__ == "__main__":
    main()
