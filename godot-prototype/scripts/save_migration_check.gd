extends Node

const MAIN_SCENE := "res://scenes/main.tscn"
const SAVE_PATH := "user://garden_state.json"
const LAYOUT_VERSION := 30
const DECOR_IDS := [
	"path",
	"bench",
	"lamp",
	"pond",
	"well",
	"workbench",
	"sign",
	"flower-rock",
	"bridge",
	"picnic"
]

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_save()
	await _test_legacy_save_migration()
	await _test_current_layout_preserves_positions()
	await _test_export_import_contract()
	_remove_save()
	_print_result()
	get_tree().quit(1 if _failed else 0)


func _test_legacy_save_migration() -> void:
	print("TEST legacy_save_migration")
	_write_save(_legacy_save_fixture())
	var main := await _load_main()
	var data := _garden_data(main)
	_assert_equal("legacy layout_version", int(data.get("layout_version", 0)), LAYOUT_VERSION)
	_assert_equal("legacy onboarding default", bool(data.get("onboarding_seen", true)), false)
	_assert_equal("legacy selected zone restored", str(data.get("selected_zone", "")), "active")
	_assert_equal("legacy active map path", str(_zone(data, "active").get("map", "")), "res://assets/sprites/sprout/maps/sprout-map-active-gpt-v4-noplot-tallfield.png")
	_assert_equal("legacy dormant map path", str(_zone(data, "dormant").get("map", "")), "res://assets/sprites/sprout/maps/sprout-map-dormant-gpt-v6-structural.png")
	_assert_near("legacy active-1 x migrated", float(_plot(data, "active", "active-1").get("x", 0.0)), 0.295)
	_assert_near("legacy active-1 y migrated", float(_plot(data, "active", "active-1").get("y", 0.0)), 0.471)
	_assert_equal("legacy course sowing migrated", str(_plot(data, "active", "active-3").get("stage", "")), "seed")
	_assert_equal("legacy course fruit migrated", str(_plot(data, "harvested", "harvested-1").get("stage", "")), "bloom")
	_assert_equal("legacy course seed_saved migrated", str(_plot(data, "dormant", "dormant-2").get("stage", "")), "blossom")
	_assert_equal("legacy course sprite updated", str(_plot(data, "active", "active-3").get("sprite", "")), "res://assets/sprites/web-normalized-stages/course-lotus-seed.png")
	_assert_equal("legacy empty portrait removed", _plot(data, "active", "active-9").has("portrait_sprite"), false)
	_assert_equal("legacy empty sprite cleared", str(_plot(data, "active", "active-9").get("sprite", "not-cleared")), "")
	_assert_equal("legacy course sessions default", int(_plot(data, "active", "active-3").get("sessions", -1)), 0)
	_assert_equal("legacy care default exists", (_plot(data, "active", "active-3").get("care_today", {}) as Dictionary).has("water"), true)
	_assert_equal("legacy quick labels exist", (_plot(data, "active", "active-3").get("quick_record_labels", []) as Array).size() >= 3, true)
	_assert_equal("legacy record history exists", typeof(_plot(data, "active", "active-3").get("record_history", null)), TYPE_ARRAY)
	_assert_equal("legacy owned bench retained", int((data.get("owned_decorations", {}) as Dictionary).get("bench", 0)), 2)
	for decor_id in DECOR_IDS:
		_assert_equal("legacy owned decor key %s" % decor_id, (data.get("owned_decorations", {}) as Dictionary).has(decor_id), true)
	var unlocked := data.get("unlocked_varieties", {}) as Dictionary
	_assert_array_has("legacy keeps planted paper maple unlocked", unlocked.get("paper", []), "paper-maple")
	_assert_array_has("legacy keeps planted course lotus unlocked", unlocked.get("course", []), "course-lotus")
	_assert_array_has("legacy initial paper ginkgo unlocked", unlocked.get("paper", []), "paper-ginkgo")
	_assert_array_has("legacy initial course daisy unlocked", unlocked.get("course", []), "course-daisy")
	_assert_equal("legacy saved file migrated", int(_read_json(SAVE_PATH).get("layout_version", 0)), LAYOUT_VERSION)
	_unload_main(main)


func _test_current_layout_preserves_positions() -> void:
	print("TEST current_layout_preserves_positions")
	_write_save(_current_layout_fixture())
	var main := await _load_main()
	var data := _garden_data(main)
	var active_1 := _plot(data, "active", "active-1")
	_assert_near("current active-1 x preserved", float(active_1.get("x", 0.0)), 0.111)
	_assert_near("current active-1 y preserved", float(active_1.get("y", 0.0)), 0.222)
	_assert_near("current active-1 size preserved", float(active_1.get("size_scale", 0.0)), 1.37)
	_assert_equal("current selected zone fallback", str(main.get("selected_zone_id")), "active")
	_unload_main(main)


func _test_export_import_contract() -> void:
	print("TEST export_import_contract")
	_write_save(_current_layout_fixture())
	var main := await _load_main()
	var payload := main.call("_make_export_payload") as Dictionary
	var valid := main.call("_extract_import_data", payload) as Dictionary
	_assert_equal("export payload accepted", bool(valid.get("ok", false)), true)
	var tampered := payload.duplicate(true)
	(tampered["data"] as Dictionary)["coins"] = 9999
	var checksum_result := main.call("_extract_import_data", tampered) as Dictionary
	_assert_equal("tampered checksum rejected", bool(checksum_result.get("ok", true)), false)
	var future := payload.duplicate(true)
	future["schema_version"] = 999
	var future_result := main.call("_extract_import_data", future) as Dictionary
	_assert_equal("future schema rejected", bool(future_result.get("ok", true)), false)
	var raw_result := main.call("_extract_import_data", payload["data"]) as Dictionary
	_assert_equal("raw data accepted", bool(raw_result.get("ok", false)), true)
	_unload_main(main)


func _load_main() -> Node:
	var scene := load(MAIN_SCENE) as PackedScene
	if scene == null:
		_fail("main scene loads", "PackedScene", "null")
		return null
	var main := scene.instantiate()
	get_tree().root.add_child(main)
	for _index in range(6):
		await get_tree().process_frame
	return main


func _unload_main(main: Node) -> void:
	if main != null:
		main.free()


func _legacy_save_fixture() -> Dictionary:
	return {
		"selected_zone": "active",
		"layout_version": 1,
		"coins": 42,
		"decoration_catalog": [],
		"owned_decorations": {"bench": 2},
		"zones": [
			{
				"id": "active",
				"title": "Active",
				"map": "res://old-map.png",
				"plots": [
					{
						"id": "active-1",
						"title": "Paper Maple",
						"kind": "paper",
						"stage": "sapling",
						"status": "Queued",
						"note": "legacy position should migrate",
						"sprite": "res://assets/sprites/web-normalized-stages/paper-maple-sapling.png",
						"x": 0.02,
						"y": 0.03,
						"size_scale": 0.42
					},
					{
						"id": "active-3",
						"title": "Course Lotus",
						"kind": "course",
						"stage": "sowing",
						"status": "Legacy",
						"note": "old course stage should migrate",
						"sprite": "res://assets/sprites/web-normalized-stages/course-lotus-sowing.png",
						"x": 0.2,
						"y": 0.2
					},
					{
						"id": "active-9",
						"title": "Empty",
						"kind": "empty",
						"stage": "empty",
						"sprite": "res://stale.png",
						"portrait_sprite": "res://stale-portrait.png",
						"x": 0.1,
						"y": 0.1
					}
				],
				"decorations": [{"id": "bench", "x": 0.01, "y": 0.01}]
			},
			{
				"id": "harvested",
				"title": "Harvested",
				"map": "res://old-harvested.png",
				"plots": [
					{
						"id": "harvested-1",
						"title": "Course Rose",
						"kind": "course",
						"stage": "fruit",
						"sprite": "res://assets/sprites/web-normalized-stages/course-rose-fruit.png",
						"x": 0.1,
						"y": 0.1
					}
				],
				"decorations": []
			},
			{
				"id": "dormant",
				"title": "Dormant",
				"map": "res://old-dormant.png",
				"plots": [
					{
						"id": "dormant-2",
						"title": "Course Hydrangea",
						"kind": "course",
						"stage": "seed_saved",
						"sprite": "res://assets/sprites/web-normalized-stages/course-hydrangea-seed_saved.png",
						"x": 0.1,
						"y": 0.1
					}
				],
				"decorations": []
			}
		]
	}


func _current_layout_fixture() -> Dictionary:
	return {
		"selected_zone": "missing-zone",
		"layout_version": LAYOUT_VERSION,
		"coins": 12,
		"decoration_catalog": [{"id": "bench", "title": "Bench", "price": 1, "sprite": "res://assets/sprites/sprout/decor/decor-wood-bench.png"}],
		"owned_decorations": {"bench": 1},
		"unlocked_varieties": {"paper": ["paper-ginkgo", "paper-cherry"], "course": ["course-daisy", "course-rose"]},
		"last_settlement_date": _today_key(),
		"zones": [
			{
				"id": "active",
				"title": "Active",
				"map": "res://stale.png",
				"plots": [
					{
						"id": "active-1",
						"title": "Paper Ginkgo",
						"kind": "paper",
						"stage": "tree",
						"status": "Custom",
						"note": "current layout position should survive",
						"sprite": "res://assets/sprites/web-normalized-stages/paper-ginkgo-tree.png",
						"x": 0.111,
						"y": 0.222,
						"size_scale": 1.37,
						"growth": 36,
						"care_today": {"water": 0, "sun": 0, "fertilizer": 0}
					}
				],
				"decorations": [{"id": "bench", "x": 0.333, "y": 0.444, "size_scale": 1.25}]
			}
		]
	}


func _garden_data(main: Node) -> Dictionary:
	if main == null:
		return {}
	return main.get("garden_data") as Dictionary


func _zone(data: Dictionary, zone_id: String) -> Dictionary:
	for zone in data.get("zones", []):
		var zone_dict := zone as Dictionary
		if str(zone_dict.get("id", "")) == zone_id:
			return zone_dict
	return {}


func _plot(data: Dictionary, zone_id: String, plot_id: String) -> Dictionary:
	for plot in _zone(data, zone_id).get("plots", []):
		var plot_dict := plot as Dictionary
		if str(plot_dict.get("id", "")) == plot_id:
			return plot_dict
	return {}


func _write_save(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		_fail("write fixture save", "file", "null")
		return
	file.store_string(JSON.stringify(data, "\t"))


func _read_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _remove_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))


func _today_key() -> String:
	return Time.get_date_string_from_system(false)


func _assert_equal(label: String, actual: Variant, expected: Variant) -> void:
	if actual != expected:
		_fail(label, expected, actual)
	else:
		print("ASSERT PASS: %s" % label)


func _assert_near(label: String, actual: float, expected: float, tolerance := 0.001) -> void:
	if abs(actual - expected) > tolerance:
		_fail(label, expected, actual)
	else:
		print("ASSERT PASS: %s" % label)


func _assert_array_has(label: String, values: Variant, expected: String) -> void:
	if typeof(values) != TYPE_ARRAY or not (values as Array).has(expected):
		_fail(label, expected, values)
	else:
		print("ASSERT PASS: %s" % label)


func _fail(label: String, expected: Variant, actual: Variant) -> void:
	_failed = true
	push_error("ASSERT FAIL: %s expected=%s actual=%s" % [label, expected, actual])
	print("ASSERT FAIL: %s expected=%s actual=%s" % [label, expected, actual])


func _print_result() -> void:
	if _failed:
		print("SAVE_MIGRATION_CHECK=FAIL")
	else:
		print("SAVE_MIGRATION_CHECK=PASS")
