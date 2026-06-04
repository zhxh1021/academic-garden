from pathlib import Path
from collections import deque

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
STAGES = ROOT / "godot-prototype" / "assets" / "sprites" / "stages"


def clean(path: Path) -> int:
    image = Image.open(path).convert("RGBA")
    pixels = list(image.getdata())
    width, height = image.size
    visited = set()
    queue = deque()
    for x in range(width):
        queue.append((x, 0))
        queue.append((x, height - 1))
    for y in range(height):
        queue.append((0, y))
        queue.append((width - 1, y))

    def is_key_color(index: int) -> bool:
        r, g, b, a = pixels[index]
        return a > 0 and r > 145 and g < 125 and b > 125

    changed = 0
    while queue:
        x, y = queue.popleft()
        if x < 0 or x >= width or y < 0 or y >= height:
            continue
        index = y * width + x
        if index in visited:
            continue
        visited.add(index)
        if not is_key_color(index):
            continue
        r, g, b, _a = pixels[index]
        pixels[index] = (r, g, b, 0)
        changed += 1
        queue.append((x + 1, y))
        queue.append((x - 1, y))
        queue.append((x, y + 1))
        queue.append((x, y - 1))

    cleaned = []
    for r, g, b, a in pixels:
        if r > 205 and g < 85 and b > 170:
            cleaned.append((r, g, b, 0))
            changed += 1
        else:
            cleaned.append((r, g, b, a))
    if changed:
        image.putdata(cleaned)
        image.save(path)
    return changed


def main() -> None:
    total = 0
    files = 0
    for path in sorted(STAGES.glob("*.png")):
        changed = clean(path)
        if changed:
            files += 1
            total += changed
            print(f"{path.name}: {changed}")
    print(f"cleaned {total} pixels in {files} files")


if __name__ == "__main__":
    main()
