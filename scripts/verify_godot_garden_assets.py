import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1] / "godot-prototype"
SEED = ROOT / "data" / "garden_seed.json"


def res_exists(path):
    return (ROOT / path.removeprefix("res://")).exists()


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    print(f"layout {data['layout_version']}")
    for zone in data["zones"]:
        xs = sorted({plot["x"] for plot in zone["plots"]})
        ys = sorted({plot["y"] for plot in zone["plots"]})
        print(f"{zone['id']} plots {len(zone['plots'])} decor {len(zone['decorations'])} xs {xs} ys {ys}")

    missing = []
    for zone in data["zones"]:
        path = zone.get("map")
        if path and path.startswith("res://") and not res_exists(path):
            missing.append((zone["id"], "map", path))
        for plot in zone["plots"]:
            for key in ("sprite", "portrait_sprite"):
                path = plot.get(key)
                if path and path.startswith("res://") and not res_exists(path):
                    missing.append((plot["id"], key, path))
    for decor in data["decoration_catalog"]:
        path = decor["sprite"]
        if path.startswith("res://") and not res_exists(path):
            missing.append((decor["id"], "sprite", path))

    print(f"missing {len(missing)}")
    for item in missing:
        print(item)
    if missing:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
