from __future__ import annotations

from pathlib import Path
from typing import Iterable

from PIL import Image, ImageChops, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "web-normalized-stages"
OUT_DIR = ROOT / "godot-prototype" / "assets" / "sprites" / "stage-animations" / "paper-trees"
ART_DIR = ROOT / "godot-prototype" / "assets" / "art"

VARIETIES = ["ginkgo", "cherry", "maple", "pine", "willow", "camphor"]
STAGES = ["tree", "flower", "fruit"]
FRAME_COUNT = 6
ANGLES = [0.0, -0.35, -0.55, -0.25, 0.35, 0.0]
GIF_DURATION_MS = 180

PETAL_PALETTES = {
    "ginkgo": ((245, 210, 67, 245), (190, 134, 37, 230), (255, 241, 136, 235)),
    "cherry": ((255, 160, 197, 248), (197, 73, 137, 232), (255, 238, 244, 238)),
    "maple": ((231, 92, 61, 245), (143, 54, 38, 230), (255, 168, 88, 235)),
    "pine": ((118, 154, 72, 245), (63, 96, 53, 230), (181, 194, 88, 235)),
    "willow": ((176, 213, 126, 240), (90, 136, 84, 225), (225, 236, 178, 230)),
    "camphor": ((114, 158, 84, 245), (62, 96, 61, 230), (196, 217, 126, 235)),
}


def is_trunk_brown(r: int, g: int, b: int) -> bool:
    return r >= 45 and g >= 24 and b <= 95 and r >= g + 10 and g >= b - 8


def is_canopy_color(r: int, g: int, b: int, a: int) -> bool:
    if a == 0:
        return False
    if is_trunk_brown(r, g, b):
        return False
    if max(r, g, b) < 35:
        return False
    if g >= r + 8 and g >= b + 8:
        return True
    if r >= 120 and r >= g + 18 and b >= 70:
        return True
    if r >= 150 and g >= 120 and b <= 105:
        return True
    if b >= r + 10 and b >= g + 10:
        return True
    return False


def canopy_mask_for(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    bbox = rgba.getbbox()
    mask = Image.new("L", rgba.size, 0)
    if bbox is None:
        return mask

    left, top, right, bottom = bbox
    base_band_top = bottom - max(34, int((bottom - top) * 0.16))
    px = rgba.load()
    mask_px = mask.load()
    for y in range(top, base_band_top):
        for x in range(left, right):
            r, g, b, a = px[x, y]
            if is_canopy_color(r, g, b, a):
                mask_px[x, y] = 255

    # Include canopy outlines without swallowing the trunk/ground.
    mask = mask.filter(ImageFilter.MaxFilter(3))
    mask = mask.filter(ImageFilter.MaxFilter(3))
    mask_px = mask.load()
    px = rgba.load()
    for y in range(top, bottom):
        for x in range(left, right):
            if mask_px[x, y] == 0:
                continue
            r, g, b, a = px[x, y]
            if a == 0 or y >= base_band_top:
                mask_px[x, y] = 0
            elif is_trunk_brown(r, g, b):
                mask_px[x, y] = 0
    return mask


def split_layers(image: Image.Image) -> tuple[Image.Image, Image.Image, Image.Image]:
    rgba = image.convert("RGBA")
    mask = canopy_mask_for(rgba)
    alpha = rgba.getchannel("A")
    blank = Image.new("L", rgba.size, 0)

    canopy = Image.new("RGBA", rgba.size, (0, 0, 0, 0))
    canopy.alpha_composite(rgba)
    canopy.putalpha(Image.composite(alpha, blank, mask))

    static = rgba.copy()
    static.putalpha(Image.composite(blank, alpha, mask))
    return static, canopy, mask


def petal_positions(size: tuple[int, int], bbox: tuple[int, int, int, int]) -> list[list[tuple[int, int]]]:
    left, top, right, bottom = bbox
    width = right - left
    height = bottom - top
    path = [
        [],
        [(0.64, 0.42), (0.78, 0.48), (0.48, 0.52)],
        [(0.66, 0.50), (0.80, 0.56), (0.50, 0.61), (0.88, 0.66), (0.38, 0.66)],
        [(0.68, 0.60), (0.82, 0.66), (0.52, 0.72), (0.90, 0.78), (0.40, 0.78)],
        [(0.70, 0.70), (0.84, 0.76), (0.54, 0.82), (0.41, 0.88)],
        [(0.73, 0.80), (0.86, 0.87), (0.56, 0.89)],
    ]
    frames: list[list[tuple[int, int]]] = []
    for frame in path:
        frames.append([(int(left + width * x), int(top + height * y)) for x, y in frame])
    return frames


def draw_petal(draw: ImageDraw.ImageDraw, x: int, y: int, palette: tuple[tuple[int, int, int, int], ...], flip: bool) -> None:
    fill, dark, hi = palette
    if flip:
        points = [(x, y, dark), (x + 1, y, fill), (x + 2, y, hi), (x + 1, y + 1, fill), (x + 2, y + 1, dark)]
    else:
        points = [(x, y, hi), (x + 1, y, fill), (x + 2, y, dark), (x, y + 1, fill), (x + 1, y + 1, dark)]
    for px, py, color in points:
        draw.point((px, py), fill=color)


def make_animation(variety: str, stage: str) -> tuple[list[Image.Image], dict[str, object]]:
    src = SOURCE_DIR / f"paper-{variety}-{stage}.png"
    image = Image.open(src).convert("RGBA")
    bbox = image.getbbox()
    if bbox is None:
        raise ValueError(f"{src} has no visible pixels")

    static, canopy, mask = split_layers(image)
    pivot = ((bbox[0] + bbox[2]) * 0.5, bbox[3] - max(12, int((bbox[3] - bbox[1]) * 0.06)))
    frames: list[Image.Image] = []
    petals = petal_positions(image.size, bbox) if stage == "tree" else [[] for _ in range(FRAME_COUNT)]
    palette = PETAL_PALETTES[variety]

    for index, angle in enumerate(ANGLES):
        frame = Image.new("RGBA", image.size, (0, 0, 0, 0))
        frame.alpha_composite(static)
        rotated = canopy.rotate(angle, resample=Image.Resampling.BICUBIC, center=pivot)
        frame.alpha_composite(rotated)
        if stage == "tree":
            draw = ImageDraw.Draw(frame)
            for petal_index, (x, y) in enumerate(petals[index]):
                draw_petal(draw, x, y, palette, (index + petal_index) % 2 == 0)
        frames.append(frame)

    return frames, {
        "source": str(src.relative_to(ROOT)),
        "size": image.size,
        "bbox": bbox,
        "mask_bbox": mask.getbbox(),
        "pivot": (round(pivot[0], 2), round(pivot[1], 2)),
        "angles": ANGLES,
        "petals": stage == "tree",
    }


def save_gif(frames: Iterable[Image.Image], out_path: Path) -> None:
    preview_frames = []
    for frame in frames:
        bg = Image.new("RGBA", frame.size, (172, 221, 195, 255))
        draw = ImageDraw.Draw(bg)
        for yy in range(0, frame.size[1], 16):
            for xx in range(0, frame.size[0], 16):
                if (xx // 16 + yy // 16) % 2 == 0:
                    draw.rectangle((xx, yy, xx + 15, yy + 15), fill=(184, 229, 203, 255))
        bg.alpha_composite(frame)
        preview_frames.append(bg.convert("P", palette=Image.Palette.ADAPTIVE))
    preview_frames[0].save(out_path, save_all=True, append_images=preview_frames[1:], duration=GIF_DURATION_MS, loop=0, disposal=2)


def save_sheet(frames: list[Image.Image], out_path: Path) -> None:
    width, height = frames[0].size
    sheet = Image.new("RGBA", (width * len(frames), height), (0, 0, 0, 0))
    for index, frame in enumerate(frames):
        sheet.alpha_composite(frame, (index * width, 0))
    sheet.save(out_path)


def save_review(records: list[tuple[str, str, Path]]) -> None:
    thumbs: list[tuple[str, Image.Image]] = []
    thumb_size = (128, 128)
    for variety, stage, frame_path in records:
        img = Image.open(frame_path).convert("RGBA")
        thumb = Image.new("RGBA", thumb_size, (0, 0, 0, 0))
        scale = min((thumb_size[0] - 8) / img.width, (thumb_size[1] - 8) / img.height)
        resized = img.resize((max(1, round(img.width * scale)), max(1, round(img.height * scale))), Image.Resampling.NEAREST)
        thumb.alpha_composite(resized, ((thumb_size[0] - resized.width) // 2, thumb_size[1] - resized.height - 4))
        thumbs.append((f"{variety}-{stage}", thumb))

    columns = 6
    cell_w, cell_h = 150, 158
    rows = (len(thumbs) + columns - 1) // columns
    review = Image.new("RGBA", (columns * cell_w, rows * cell_h), (239, 245, 226, 255))
    draw = ImageDraw.Draw(review)
    for index, (label, thumb) in enumerate(thumbs):
        col = index % columns
        row = index // columns
        x = col * cell_w
        y = row * cell_h
        draw.text((x + 8, y + 6), label, fill=(47, 54, 42, 255))
        review.alpha_composite(thumb, (x + 11, y + 26))
    review.save(ART_DIR / "paper-tree-stage-animation-v1-review.png")


def main() -> None:
    records: list[tuple[str, str, Path]] = []
    metadata_lines = [
        "Paper tree stage animation v1",
        f"angles_degrees={ANGLES}",
        "third-column tree stages include falling petals/leaves; fourth/fifth flower/fruit stages sway only.",
        "",
    ]
    for variety in VARIETIES:
        for stage in STAGES:
            frames, metadata = make_animation(variety, stage)
            anim_dir = OUT_DIR / f"paper-{variety}-{stage}"
            anim_dir.mkdir(parents=True, exist_ok=True)
            for index, frame in enumerate(frames):
                frame.save(anim_dir / f"frame-{index:02d}.png")
            save_sheet(frames, anim_dir / "sheet.png")
            save_gif(frames, ART_DIR / f"paper-{variety}-{stage}-animation-v1.gif")
            records.append((variety, stage, anim_dir / "frame-02.png"))
            metadata_lines.append(f"paper-{variety}-{stage}: {metadata}")
    save_review(records)
    (ART_DIR / "paper-tree-stage-animation-v1.txt").write_text("\n".join(metadata_lines) + "\n", encoding="utf-8")
    print(f"Wrote {len(records)} animations under {OUT_DIR}")
    print(f"Wrote previews under {ART_DIR}")


if __name__ == "__main__":
    main()
