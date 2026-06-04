from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
NORMALIZED = ROOT / "godot-prototype" / "assets" / "sprites" / "web-normalized-stages"
OUT = ROOT / "godot-prototype" / "assets" / "art" / "godot-normalized-stage-sheet.png"


def main() -> None:
    files = sorted(NORMALIZED.glob("*.png"))
    cols = 4
    cell_w, cell_h = 250, 310
    sheet = Image.new("RGB", (cols * cell_w, ((len(files) + cols - 1) // cols) * cell_h), "#edf2d4")
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.load_default()
    for i, path in enumerate(files):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        image = Image.open(path).convert("RGBA")
        bbox = image.getchannel("A").getbbox()
        draw.rectangle((x + 8, y + 8, x + cell_w - 8, y + cell_h - 8), fill="#f7f2df", outline="#8b7b51")
        draw.text((x + 14, y + 14), path.name, fill="#24351f", font=font)
        draw.text((x + 14, y + 30), f"{image.width}x{image.height} bbox={bbox}", fill="#5f5132", font=font)
        frame = (x + 25, y + 56, x + cell_w - 25, y + cell_h - 20)
        draw.rectangle(frame, fill="#b7cb7b", outline="#5f7041")
        scale = min((frame[2] - frame[0] - 10) / image.width, (frame[3] - frame[1] - 10) / image.height)
        view = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.LANCZOS)
        sheet.paste(view, (frame[0] + ((frame[2] - frame[0]) - view.width) // 2, frame[3] - view.height - 5), view)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(OUT)
    print(OUT)


if __name__ == "__main__":
    main()
