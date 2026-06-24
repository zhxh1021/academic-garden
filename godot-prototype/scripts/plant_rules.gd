extends RefCounted

const STAGE_FLOW := {
	"paper": ["seed", "sapling", "tree", "flower", "fruit"],
	"course": ["seed", "seedling", "bud", "bloom", "blossom"]
}
const COURSE_STAGE_KEY_MIGRATIONS := {
	"sowing": "seed",
	"growing": "seedling",
	"fruit": "bloom",
	"seed_saved": "blossom",
	"fruit-bloom": "bloom",
	"seed_saved-blossom": "blossom"
}
const COURSE_STAGE_SUFFIXES := [
	"-bud-bloom",
	"-fruit-bloom",
	"-seed_saved-blossom",
	"-seed_saved",
	"-sowing",
	"-growing",
	"-fruit",
	"-seed",
	"-seedling",
	"-bud",
	"-blossom"
]


static func normalize_stage_key(kind: String, stage: String) -> String:
	if kind != "course":
		return stage
	return str(COURSE_STAGE_KEY_MIGRATIONS.get(stage, stage))


static func next_stage(kind: String, stage: String) -> String:
	var flow: Array = STAGE_FLOW.get(kind, [])
	var index := flow.find(stage)
	if index < 0 or index >= flow.size() - 1:
		return ""
	return str(flow[index + 1])


static func is_final_stage(kind: String, stage: String) -> bool:
	var flow: Array = STAGE_FLOW.get(kind, [])
	return flow.size() > 0 and stage == str(flow[flow.size() - 1])


static func plant_variety_base(plot: Dictionary) -> String:
	var kind := str(plot.get("kind", ""))
	if kind.is_empty() or kind == "empty":
		return ""
	var file_name := str(plot.get("sprite", "")).get_file().get_basename()
	if file_name.ends_with("-rebuilt"):
		file_name = file_name.trim_suffix("-rebuilt")
	if file_name.ends_with("-full"):
		file_name = file_name.trim_suffix("-full")
	if kind == "course":
		for legacy_suffix in COURSE_STAGE_SUFFIXES:
			if file_name.ends_with(legacy_suffix):
				return file_name.trim_suffix(legacy_suffix)
	var current_stage := str(plot.get("stage", ""))
	var stage_marker := "-%s" % current_stage
	if not current_stage.is_empty() and file_name.contains(stage_marker):
		return file_name.split(stage_marker, false, 1)[0]
	var flow: Array = STAGE_FLOW.get(kind, [])
	for stage in flow:
		var suffix := "-%s" % stage
		if file_name.ends_with(suffix):
			return file_name.trim_suffix(suffix)
	return file_name


static func default_growth_for_stage(plot: Dictionary, milestone_growth: int) -> int:
	var kind := str(plot.get("kind", ""))
	var flow: Array = STAGE_FLOW.get(kind, [])
	var index := flow.find(str(plot.get("stage", "")))
	return maxi(index, 0) * milestone_growth


static func web_stage_sprite_path(plot: Dictionary) -> String:
	var base := plant_variety_base(plot)
	if base.is_empty():
		return str(plot.get("sprite", ""))
	return web_stage_file_path("%s-%s" % [base, str(plot.get("stage", ""))])


static func web_stage_file_path(file_base: String) -> String:
	return "res://assets/sprites/web-normalized-stages/%s.png" % file_base


static func plant_sprite_base(path: String) -> String:
	var file_name := path.get_file().get_basename()
	if file_name.is_empty() or file_name.begins_with("empty-plot"):
		return ""
	if file_name.ends_with("-rebuilt"):
		file_name = file_name.trim_suffix("-rebuilt")
	if file_name.ends_with("-portrait"):
		file_name = file_name.trim_suffix("-portrait")
	if file_name.ends_with("-full"):
		file_name = file_name.trim_suffix("-full")
	return file_name
