import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SEED = ROOT / "godot-prototype" / "data" / "garden_seed.json"

STAGE_FLOW = {
    "paper": ["seed", "sapling", "tree", "flower", "fruit"],
    "course": ["sowing", "growing", "bloom", "fruit", "seed_saved"],
}

ZONE_MAPS = {
    "active": "res://assets/sprites/sprout/maps/sprout-map-active-gpt-v5-noplot.png",
    "harvested": "res://assets/sprites/sprout/maps/sprout-map-harvested-gpt-v5-noplot.png",
    "dormant": "res://assets/sprites/sprout/maps/sprout-map-dormant-gpt-v5-noplot.png",
}


def plant_base(plot):
    file_name = Path(plot.get("sprite", "")).stem
    if file_name.endswith("-rebuilt"):
        file_name = file_name.removesuffix("-rebuilt")
    if file_name.endswith("-portrait"):
        file_name = file_name.removesuffix("-portrait")
    if file_name.endswith("-full"):
        file_name = file_name.removesuffix("-full")

    stage_marker = f"-{plot.get('stage', '')}"
    if stage_marker != "-" and stage_marker in file_name:
        return file_name.split(stage_marker, 1)[0]

    for stage in STAGE_FLOW.get(plot.get("kind", ""), []):
        suffix = f"-{stage}"
        if file_name.endswith(suffix):
            return file_name.removesuffix(suffix)
    return file_name


def stage_sprite(base: str, stage: str) -> str:
    normalized = ROOT / "godot-prototype" / "assets" / "sprites" / "web-normalized-stages" / f"{base}-{stage}.png"
    if normalized.exists():
        return f"res://assets/sprites/web-normalized-stages/{base}-{stage}.png"
    full = ROOT / "godot-prototype" / "assets" / "sprites" / "stages" / f"{base}-{stage}-full.png"
    suffix = "-full" if full.exists() else ""
    return f"res://assets/sprites/stages/{base}-{stage}{suffix}.png"


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    data["layout_version"] = 10
    for zone in data["zones"]:
        zone["map"] = ZONE_MAPS.get(zone["id"], zone.get("map", ""))
        for plot in zone["plots"]:
            if plot.get("kind") not in STAGE_FLOW:
                continue
            base = plant_base(plot)
            sprite = stage_sprite(base, plot.get("stage", ""))
            plot["sprite"] = sprite
            plot["portrait_sprite"] = sprite

    SEED.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
