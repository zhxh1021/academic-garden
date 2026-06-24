extends Node

const MAIN_SCENE := "res://scenes/main.tscn"
const DAILY_COIN_RANDOM_MIN := 0.95
const DAILY_COIN_RANDOM_MAX := 1.05
const DAILY_COIN_PLANT_CAP := 30
const CURRENT_DECORATION_SET_COST := 765

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var main := await _load_main()
	if main == null:
		_print_result()
		get_tree().quit(1)
		return

	_test_daily_growth_formula(main)
	_test_coin_formula_examples(main)
	_test_settlement_zone_rules(main)
	_test_milestone_growth_without_direct_coins(main)
	_test_seed_unlock_prices(main)
	_test_representative_profiles(main)

	main.free()
	_print_result()
	get_tree().quit(1 if _failed else 0)


func _test_daily_growth_formula(main: Node) -> void:
	print("TEST daily_growth_formula")
	_assert_equal("growth 1/0/0", int(main.call("_daily_growth_from_care", {"water": 1, "sun": 0, "fertilizer": 0})), 3)
	_assert_equal("growth 2/0/0", int(main.call("_daily_growth_from_care", {"water": 2, "sun": 0, "fertilizer": 0})), 6)
	_assert_equal("growth 1/1/0", int(main.call("_daily_growth_from_care", {"water": 1, "sun": 1, "fertilizer": 0})), 8)
	_assert_equal("growth 1/1/1", int(main.call("_daily_growth_from_care", {"water": 1, "sun": 1, "fertilizer": 1})), 15)
	_assert_equal("growth 2/2/2 cap", int(main.call("_daily_growth_from_care", {"water": 2, "sun": 2, "fertilizer": 2})), 18)


func _test_coin_formula_examples(main: Node) -> void:
	print("TEST coin_formula_examples")
	for row in [
		{"growth": 18, "seed": 3, "bud": 5, "fruit": 7},
		{"growth": 54, "seed": 6, "bud": 10, "fruit": 15},
		{"growth": 100, "seed": 8, "bud": 13, "fruit": 20},
		{"growth": 180, "seed": 10, "bud": 17, "fruit": 26}
	]:
		var growth := int(row["growth"])
		_assert_equal("coins growth %d seed" % growth, _coins(main, "seed", growth), int(row["seed"]))
		_assert_equal("coins growth %d stage2" % growth, _coins(main, "bud", growth), int(row["bud"]))
		_assert_equal("coins growth %d stage4" % growth, _coins(main, "fruit", growth), int(row["fruit"]))
	_assert_equal("coins negative growth floor", _coins(main, "fruit", -20), 0)
	_assert_equal("coins huge growth cap", _coins(main, "fruit", 999999), DAILY_COIN_PLANT_CAP)


func _test_settlement_zone_rules(main: Node) -> void:
	print("TEST settlement_zone_rules")
	var active := _plot("active-1", "paper", "tree", 54, {"water": 1, "sun": 1, "fertilizer": 1})
	var harvested := _plot("harvested-1", "paper", "fruit", 180, {"water": 2, "sun": 2, "fertilizer": 2})
	var dormant := _plot("dormant-1", "paper", "fruit", 180, {"water": 2, "sun": 2, "fertilizer": 2})
	main.set("garden_data", {
		"coins": 10,
		"last_settlement_date": "2000-01-01",
		"zones": [
			{"id": "active", "plots": [active], "decorations": []},
			{"id": "harvested", "plots": [harvested], "decorations": []},
			{"id": "dormant", "plots": [dormant], "decorations": []}
		],
		"decoration_catalog": [],
		"owned_decorations": {}
	})
	var active_min := _coins_with_factor(main, active.duplicate(true), DAILY_COIN_RANDOM_MIN)
	var active_after := active.duplicate(true)
	active_after["growth"] = 69
	var active_max := _coins_with_factor(main, active_after, DAILY_COIN_RANDOM_MAX)
	var harvested_min := _coins_with_factor(main, harvested.duplicate(true), DAILY_COIN_RANDOM_MIN)
	var harvested_max := _coins_with_factor(main, harvested.duplicate(true), DAILY_COIN_RANDOM_MAX)

	main.call("_settle_daily_economy")
	var data := main.get("garden_data") as Dictionary
	var active_after_settle := _find_plot(data, "active", "active-1")
	var harvested_after_settle := _find_plot(data, "harvested", "harvested-1")
	var dormant_after_settle := _find_plot(data, "dormant", "dormant-1")
	var summary := data.get("last_settlement_summary", {}) as Dictionary
	var coins_added := int(data.get("coins", 0)) - 10
	_assert_equal("settlement active growth from care", int(active_after_settle.get("growth", 0)), 69)
	_assert_equal("settlement active care reset water", int((active_after_settle.get("care_today", {}) as Dictionary).get("water", -1)), 0)
	_assert_equal("settlement harvested growth fixed", int(harvested_after_settle.get("growth", 0)), 180)
	_assert_equal("settlement dormant growth unchanged", int(dormant_after_settle.get("growth", 0)), 180)
	_assert_equal("settlement dormant care unchanged", int((dormant_after_settle.get("care_today", {}) as Dictionary).get("water", 0)), 2)
	_assert_equal("settlement summary growth", int(summary.get("growth", 0)), 15)
	_assert_equal("settlement summary plants", int(summary.get("plants", 0)), 2)
	_assert_between("settlement coins random bounded", coins_added, active_min + harvested_min, active_max + harvested_max)


func _test_milestone_growth_without_direct_coins(main: Node) -> void:
	print("TEST milestone_growth_without_direct_coins")
	main.set("selected_zone_id", "active")
	main.set("selected_plot_id", "active-1")
	main.set("garden_data", {
		"coins": 77,
		"selected_zone": "active",
		"zones": [
			{"id": "active", "plots": [_plot("active-1", "paper", "seed", 0, {"water": 0, "sun": 0, "fertilizer": 0})], "decorations": []},
			{"id": "harvested", "plots": [], "decorations": []},
			{"id": "dormant", "plots": [], "decorations": []}
		],
		"decoration_catalog": [],
		"owned_decorations": {}
	})
	main.call("_on_advance_pressed")
	var data := main.get("garden_data") as Dictionary
	var advanced := _find_plot(data, "active", "active-1")
	_assert_equal("milestone next stage", str(advanced.get("stage", "")), "sapling")
	_assert_equal("milestone adds growth", int(advanced.get("growth", 0)), 18)
	_assert_equal("milestone no direct coins", int(data.get("coins", 0)), 77)


func _test_seed_unlock_prices(main: Node) -> void:
	print("TEST seed_unlock_prices")
	main.set("garden_data", {"unlocked_varieties": {"paper": ["paper-ginkgo", "paper-cherry"], "course": ["course-daisy", "course-rose"]}})
	_assert_equal("course unlock flat price", int(main.call("_variety_unlock_price", "course")), 150)
	_assert_equal("first extra tree unlock price", int(main.call("_variety_unlock_price", "paper")), 240)
	main.set("garden_data", {"unlocked_varieties": {"paper": ["paper-ginkgo", "paper-cherry", "paper-maple"], "course": ["course-daisy", "course-rose"]}})
	_assert_equal("second extra tree unlock doubles", int(main.call("_variety_unlock_price", "paper")), 480)


func _test_representative_profiles(main: Node) -> void:
	print("TEST representative_profiles")
	var light := _profile_income(main, 2, 2)
	var normal := _profile_income(main, 5, 3)
	var heavy := _profile_income(main, 12, 4)
	var historical := _profile_income(main, 25, 0)
	_assert_between("light profile daily income", light, 45, 65)
	_assert_between("normal profile daily income", normal, 95, 135)
	_assert_between("heavy profile daily income", heavy, 210, 275)
	_assert_between("historical profile daily income", historical, 360, 470)
	_assert_between("light days for decor set", int(ceil(float(CURRENT_DECORATION_SET_COST) / float(light))), 12, 18)
	_assert_between("normal days for decor set", int(ceil(float(CURRENT_DECORATION_SET_COST) / float(normal))), 6, 9)
	_assert_between("heavy days for decor set", int(ceil(float(CURRENT_DECORATION_SET_COST) / float(heavy))), 3, 4)


func _profile_income(main: Node, harvested_count: int, active_count: int) -> int:
	var total := 0
	for _i in range(harvested_count):
		total += _coins(main, "fruit", 72)
	for _i in range(active_count):
		total += _coins(main, "bloom", 54)
	return total


func _coins(main: Node, stage: String, growth: int) -> int:
	return _coins_with_factor(main, {"stage": stage, "growth": growth}, 1.0)


func _coins_with_factor(main: Node, plot: Dictionary, factor: float) -> int:
	return int(main.call("_daily_coins_for_plot_with_factor", plot, factor))


func _plot(id: String, kind: String, stage: String, growth: int, care: Dictionary) -> Dictionary:
	return {
		"id": id,
		"title": id,
		"kind": kind,
		"stage": stage,
		"status": "Testing",
		"note": "Economy fixture",
		"sprite": "res://assets/sprites/web-normalized-stages/paper-ginkgo-%s.png" % stage,
		"x": 0.5,
		"y": 0.5,
		"growth": growth,
		"care_today": care.duplicate(true)
	}


func _find_plot(data: Dictionary, zone_id: String, plot_id: String) -> Dictionary:
	for zone in data.get("zones", []):
		var zone_dict := zone as Dictionary
		if str(zone_dict.get("id", "")) != zone_id:
			continue
		for plot in zone_dict.get("plots", []):
			var plot_dict := plot as Dictionary
			if str(plot_dict.get("id", "")) == plot_id:
				return plot_dict
	return {}


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


func _assert_equal(label: String, actual: Variant, expected: Variant) -> void:
	if actual != expected:
		_fail(label, expected, actual)
	else:
		print("ASSERT PASS: %s" % label)


func _assert_between(label: String, actual: int, minimum: int, maximum: int) -> void:
	if actual < minimum or actual > maximum:
		_fail(label, "%d..%d" % [minimum, maximum], actual)
	else:
		print("ASSERT PASS: %s = %d" % [label, actual])


func _fail(label: String, expected: Variant, actual: Variant) -> void:
	_failed = true
	push_error("ASSERT FAIL: %s expected=%s actual=%s" % [label, expected, actual])
	print("ASSERT FAIL: %s expected=%s actual=%s" % [label, expected, actual])


func _print_result() -> void:
	if _failed:
		print("ECONOMY_BALANCE_CHECK=FAIL")
	else:
		print("ECONOMY_BALANCE_CHECK=PASS")
