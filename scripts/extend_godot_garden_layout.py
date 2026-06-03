import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SEED = ROOT / "godot-prototype" / "data" / "garden_seed.json"

ANCHORS = {
    1: (0.293, 0.488),
    2: (0.503, 0.488),
    3: (0.719, 0.488),
    4: (0.293, 0.585),
    5: (0.503, 0.585),
    6: (0.719, 0.585),
    7: (0.293, 0.676),
    8: (0.503, 0.676),
    9: (0.719, 0.676),
}

NEW_PLOTS = {
    "harvested": {
        3: ("Paper Cherry", "paper", "fruit", "Harvested", "Accepted paper with final summary notes."),
        4: ("Course Lavender", "course", "seed_saved", "Archived", "Course material distilled into reusable seeds."),
        5: ("Paper Ginkgo", "paper", "flower", "Published", "A completed reading trail with useful citations."),
        6: ("Course Lotus", "course", "fruit", "Completed", "Finished exercises and reflections."),
        7: ("Paper Maple", "paper", "fruit", "Harvested", "Methods notes are ready for reuse."),
        8: ("Course Daisy", "course", "seed_saved", "Archived", "Small course loop closed cleanly."),
        9: ("Empty Plot", "empty", "empty", "Available", "Reserved for future completed work."),
    },
    "dormant": {
        3: ("Paper Willow", "paper", "sapling", "Paused", "Literature cluster waiting for a better moment."),
        4: ("Course Rose", "course", "growing", "Paused", "Practice cycle stopped midway."),
        5: ("Paper Maple", "paper", "seed", "Someday", "A captured idea with no active reading yet."),
        6: ("Course Lotus", "course", "sowing", "Waiting", "Course seed waiting for the next study sprint."),
        7: ("Empty Plot", "empty", "empty", "Available", "Quiet land for parked ideas."),
        8: ("Paper Ginkgo", "paper", "sapling", "Paused", "Useful but not urgent."),
        9: ("Empty Plot", "empty", "empty", "Available", "Open dormant space."),
    },
}

DECORATIONS = {
    "active": [
        ("bench", 0.170, 0.822),
        ("lamp", 0.835, 0.806),
        ("pond", 0.705, 0.832),
        ("sign", 0.148, 0.424),
        ("flower-rock", 0.842, 0.620),
    ],
    "harvested": [
        ("well", 0.160, 0.800),
        ("picnic", 0.735, 0.832),
        ("path", 0.500, 0.775),
        ("bench", 0.820, 0.615),
        ("workbench", 0.172, 0.430),
    ],
    "dormant": [
        ("pond", 0.180, 0.812),
        ("sign", 0.830, 0.548),
        ("lamp", 0.220, 0.430),
        ("flower-rock", 0.790, 0.820),
        ("bridge", 0.500, 0.772),
    ],
}


def sprite_path(kind, title, stage):
    if kind == "empty":
        return "res://assets/sprites/sprout/ground/empty-plot-sign.png"
    slug = title.lower().replace(" ", "-")
    return f"res://assets/sprites/sprout/plants-rebuilt/{slug}-{stage}-rebuilt.png"


def portrait_path(kind, title, stage):
    if kind == "empty":
        return None
    slug = title.lower().replace(" ", "-")
    return f"res://assets/sprites/sprout/portraits/{slug}-{stage}-portrait.png"


def normalize_plot(zone_id, index, plot):
    x, y = ANCHORS[index]
    plot["id"] = f"{zone_id}-{index}"
    plot["x"] = x
    plot["y"] = y
    plot.setdefault("visits", 0)
    plot.setdefault("logs", 0)
    plot.setdefault("size_scale", 1.0)
    if plot.get("kind") == "empty":
        plot["sprite"] = "res://assets/sprites/sprout/ground/empty-plot-sign.png"
        plot.pop("portrait_sprite", None)
    return plot


def make_plot(zone_id, index, fields):
    title, kind, stage, status, note = fields
    plot = {
        "title": title,
        "kind": kind,
        "stage": stage,
        "status": status,
        "note": note,
        "sprite": sprite_path(kind, title, stage),
        "visits": 0,
        "logs": 0,
        "size_scale": 1.0,
    }
    portrait = portrait_path(kind, title, stage)
    if portrait:
        plot["portrait_sprite"] = portrait
    return normalize_plot(zone_id, index, plot)


def main():
    data = json.loads(SEED.read_text(encoding="utf-8"))
    data["layout_version"] = 4
    for zone in data["zones"]:
        zone_id = zone["id"]
        by_index = {}
        for plot in zone.get("plots", []):
            try:
                index = int(str(plot.get("id", "")).split("-")[-1])
            except ValueError:
                continue
            by_index[index] = plot
        for index, fields in NEW_PLOTS.get(zone_id, {}).items():
            by_index.setdefault(index, make_plot(zone_id, index, fields))
        zone["plots"] = [normalize_plot(zone_id, index, by_index[index]) for index in range(1, 10) if index in by_index]
        zone["decorations"] = [
            {"id": decor_id, "x": x, "y": y, "size_scale": 1.0}
            for decor_id, x, y in DECORATIONS[zone_id]
        ]
    owned = data.setdefault("owned_decorations", {})
    for decor_id in ["path", "bench", "lamp", "pond", "well", "workbench", "sign", "flower-rock", "bridge", "picnic"]:
        owned.setdefault(decor_id, 1)
    SEED.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
