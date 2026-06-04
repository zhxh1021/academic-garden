from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-prototype"
STAGES = GODOT / "assets" / "sprites" / "stages"
SEED = GODOT / "data" / "garden_seed.json"
OUT = GODOT / "assets" / "art" / "godot-stage-fit-audit.png"

STAGE_SIZES = {
    ("paper", "seed"): (66, 70),
    ("paper", "sapling"): (86, 110),
    ("paper", "tree"): (148, 176),
    ("paper", "flower"): (148, 176),
    ("paper", "fruit"): (148, 176),
    ("course", "sowing"): (62, 70),
    ("course", "growing"): (104, 130),
    ("course", "bloom"): (116, 142),
    ("course", "fruit"): (116, 142),
    ("course", "seed_saved"): (116, 142),
}


def res(path: str) -> Path:
    return GODOT / path.removeprefix("res://")


def alpha_bbox(image: Image.Image):
    return image.convert("RGBA").getchannel("A").getbbox()


def touches_edge(image: Image.Image) -> str:
    bbox = alpha_bbox(image)
    if bbox is None:
        return "empty"
    l, t, r, b = bbox
    flags = []
    if l <= 0:
        flags.append("L")
    if t <= 0:
        flags.append("T")
    if r >= image.width:
        flags.append("R")
    if b >= image.height:
        flags.append("B")
    return "".join(flags) or "-"


def fit(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    image = image.convert("RGBA")
    scale = min(size[0] / image.width, size[1] / image.height)
    new_size = (max(1, round(image.width * scale)), max(1, round(image.height * scale)))
    return image.resize(new_size, Image.Resampling.LANCZOS)


def collect_used():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    rows = []
    seen = set()
    for zone in data["zones"]:
        for plot in zone["plots"]:
            if plot.get("kind") not in ("paper", "course"):
                continue
            key = (plot["kind"], plot["stage"], plot["sprite"])
            if key in seen:
                continue
            seen.add(key)
            rows.append(
                {
                    "kind": plot["kind"],
                    "stage": plot["stage"],
                    "title": plot.get("title", ""),
                    "path": plot["sprite"],
                    "size": STAGE_SIZES[(plot["kind"], plot["stage"])],
                }
            )
    return rows


def make_sheet(rows):
    cell_w, cell_h = 330, 220
    cols = 3
    sheet = Image.new("RGB", (cell_w * cols, cell_h * ((len(rows) + cols - 1) // cols)), "#e8efd0")
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.load_default()
    for index, row in enumerate(rows):
        x = (index % cols) * cell_w
        y = (index // cols) * cell_h
        path = res(row["path"])
        image = Image.open(path).convert("RGBA")
        bbox = alpha_bbox(image)
        edge = touches_edge(image)
        fitted = fit(image, row["size"])
        label = f"{row['kind']} {row['stage']}  {path.name}"
        metrics = f"src {image.width}x{image.height} bbox {bbox} edge {edge} fit {row['size'][0]}x{row['size'][1]}->{fitted.width}x{fitted.height}"

        draw.rectangle((x + 8, y + 8, x + cell_w - 8, y + cell_h - 8), fill="#f7f3df", outline="#8d7b4a")
        draw.text((x + 14, y + 14), label, fill="#26371f", font=font)
        draw.text((x + 14, y + 30), metrics, fill="#5d4c2f", font=font)
        draw.rectangle((x + 22, y + 56, x + 162, y + 194), fill="#b5c979", outline="#5f6f42")
        draw.rectangle((x + 190, y + 56, x + 190 + row["size"][0], y + 56 + row["size"][1]), fill="#b5c979", outline="#5f6f42")

        thumb = fit(image, (132, 132))
        sheet.paste(thumb, (x + 92 - thumb.width // 2, y + 125 - thumb.height // 2), thumb)
        sheet.paste(fitted, (x + 190 + (row["size"][0] - fitted.width) // 2, y + 56 + row["size"][1] - fitted.height), fitted)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(OUT)
    print(OUT)


def main():
    rows = collect_used()
    for row in rows:
        image = Image.open(res(row["path"])).convert("RGBA")
        print(
            f"{row['kind']:6} {row['stage']:10} {Path(row['path']).name:42} "
            f"src={image.width}x{image.height} bbox={alpha_bbox(image)} edge={touches_edge(image)} fit={row['size']}"
        )
    make_sheet(rows)


if __name__ == "__main__":
    main()
