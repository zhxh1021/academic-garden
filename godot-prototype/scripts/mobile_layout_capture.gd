extends Node

const MAIN_SCENE := "res://scenes/main.tscn"
const DEFAULT_WIDTH := 390
const DEFAULT_HEIGHT := 844
const DEFAULT_LABEL := "390x844"
const FRAMES_PER_VIEW := 6
const VIEWS := [
	"active-map",
	"harvested-map",
	"dormant-map",
	"detail-active",
	"record-drawer",
	"seed-shop",
	"decor-shop",
	"backup-panel",
	"onboarding",
	"remove-confirmation"
]

var _main: Node
var _out_dir := ""
var _width := DEFAULT_WIDTH
var _height := DEFAULT_HEIGHT
var _failed := false
var _view_index := -1
var _view_frame := 0
var _done := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_width = _env_int("AG_CAPTURE_WIDTH", DEFAULT_WIDTH)
	_height = _env_int("AG_CAPTURE_HEIGHT", DEFAULT_HEIGHT)
	var label := OS.get_environment("AG_CAPTURE_LABEL")
	if label.is_empty():
		label = "%sx%s" % [_width, _height]
	_out_dir = ProjectSettings.globalize_path("res://screenshots/mobile-layout/%s" % label)
	_prepare_viewport()
	_prepare_output_dir()

	var scene := load(MAIN_SCENE) as PackedScene
	if scene == null:
		_fail("Main scene could not be loaded: %s" % MAIN_SCENE)
		get_tree().quit(1)
		return

	_main = scene.instantiate()
	get_tree().root.add_child(_main)
	await _settle_frames(10)
	_assert_viewport_size()
	_next_view()


func _process(_delta: float) -> void:
	if _done or _failed or _view_index < 0:
		return
	_view_frame += 1
	if _view_frame >= FRAMES_PER_VIEW:
		_save_named_capture(VIEWS[_view_index])
		_next_view()


func _prepare_viewport() -> void:
	var size := Vector2i(_width, _height)
	DisplayServer.window_set_size(size)
	get_tree().root.size = size
	get_tree().root.content_scale_size = size


func _prepare_output_dir() -> void:
	var error := DirAccess.make_dir_recursive_absolute(_out_dir)
	if error != OK:
		_fail("Could not create capture directory: %s error=%s" % [_out_dir, error])


func _next_view() -> void:
	_view_index += 1
	_view_frame = 0
	if _view_index >= VIEWS.size():
		_done = true
		print("CAPTURE_OUT_DIR=%s" % _out_dir)
		get_tree().quit(0)
		return
	_show_view(VIEWS[_view_index])


func _show_view(view_name: String) -> void:
	_reset_surface()
	match view_name:
		"active-map":
			_main.call("_switch_zone", "active")
			_main.call("_close_detail")
		"harvested-map":
			_main.call("_switch_zone", "harvested")
			_main.call("_close_detail")
		"dormant-map":
			_main.call("_switch_zone", "dormant")
			_main.call("_close_detail")
		"detail-active":
			_main.call("_switch_zone", "active")
			_main.call("_select_plot", "active-1")
		"record-drawer":
			_main.call("_switch_zone", "active")
			_main.call("_select_plot", "active-1")
			_main.call("_show_record_panel")
		"seed-shop":
			_main.call("_switch_zone", "active")
			_main.call("_close_detail")
			_main.call("_set_decor_mode", "seed_shop")
		"decor-shop":
			_main.call("_switch_zone", "active")
			_main.call("_close_detail")
			_main.call("_set_decor_mode", "shop")
		"backup-panel":
			_main.call("_switch_zone", "active")
			_main.call("_close_detail")
			_main.call("_show_backup_panel")
		"onboarding":
			_main.call("_switch_zone", "active")
			_main.call("_close_detail")
			_main.call("_show_onboarding", false)
		"remove-confirmation":
			_main.call("_switch_zone", "active")
			_main.call("_select_plot", "active-1")
			_main.call("_show_remove_confirmation")
		_:
			_fail("Unknown capture view: %s" % view_name)
			return

	print("CAPTURE_VIEW %s INDEX %s" % [view_name, _view_index])


func _reset_surface() -> void:
	for method_name in [
		"_hide_remove_confirmation",
		"_hide_backup_panel",
		"_hide_record_panel",
		"_hide_record_history_panel",
		"_hide_plant_panel"
	]:
		if _main.has_method(method_name):
			_main.call(method_name)
	if _main.has_method("_set_decor_mode"):
		_main.call("_set_decor_mode", "inventory")
	var onboarding := _main.get("onboarding_overlay") as Control
	if onboarding != null:
		onboarding.visible = false


func _assert_viewport_size() -> void:
	var actual := get_tree().root.size
	if actual != Vector2i(_width, _height):
		_fail("Viewport size expected %sx%s but got %sx%s" % [_width, _height, actual.x, actual.y])
	else:
		print("ASSERT PASS: viewport size %sx%s" % [actual.x, actual.y])


func _save_named_capture(view_name: String) -> void:
	var image := get_viewport().get_texture().get_image()
	if image == null or image.is_empty():
		_fail("Could not read viewport image for %s" % view_name)
		return
	var path := "%s/%s.png" % [_out_dir, view_name]
	var error := image.save_png(path)
	if error != OK:
		_fail("Could not save capture %s error=%s" % [path, error])
	else:
		print("CAPTURE_SAVED %s" % path)


func _settle_frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _env_int(name: String, fallback: int) -> int:
	var value := OS.get_environment(name)
	if value.is_valid_int():
		return int(value)
	return fallback


func _fail(message: String) -> void:
	_failed = true
	push_error("ASSERT FAIL: %s" % message)
	print("ASSERT FAIL: %s" % message)
