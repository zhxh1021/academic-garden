extends Control

const SAVE_PATH := "user://garden_state.json"
const SEED_PATH := "res://data/garden_seed.json"
const DEBUG_EXPORT_PATH := "user://layout_debug_export.json"
const DEBUG_EXPORT_PROJECT_PATH := "res://layout_debug_export.json"
const LAYOUT_VERSION := 19
const MAP_DISPLAY_ASPECT := 780.0 / 1240.0
const EMPTY_PLOT_SIGN_SPRITE := "res://assets/sprites/sprout/ground/empty-plot-square-gpt-v1.png"
const ZONE_MAP_PATHS := {
	"active": "res://assets/sprites/sprout/maps/sprout-map-active-gpt-v4-noplot-tallfield.png",
	"harvested": "res://assets/sprites/sprout/maps/sprout-map-harvested-gpt-v6-structural.png",
	"dormant": "res://assets/sprites/sprout/maps/sprout-map-dormant-gpt-v6-structural.png"
}
const ZONE_SPRITE_FILTERS := {
	"active": {"color": Color(1.0, 1.0, 1.0, 1.0), "strength": 0.0, "brightness": 1.0},
	"harvested": {"color": Color(1.0, 0.70, 0.24, 1.0), "strength": 0.48, "brightness": 0.94},
	"dormant": {"color": Color(0.22, 0.31, 0.40, 1.0), "strength": 0.72, "brightness": 0.58}
}
const DEFAULT_PLOT_SIZES := {
	"paper": Vector2(96, 108),
	"course": Vector2(88, 98),
	"empty": Vector2(72, 72)
}
const STAGE_PLOT_SIZES := {
	"paper:seed": Vector2(52, 56),
	"paper:sapling": Vector2(68, 88),
	"paper:tree": Vector2(116, 138),
	"paper:flower": Vector2(116, 138),
	"paper:fruit": Vector2(116, 138),
	"course:sowing": Vector2(50, 56),
	"course:growing": Vector2(82, 102),
	"course:bloom": Vector2(92, 112),
	"course:fruit": Vector2(92, 112),
	"course:seed_saved": Vector2(92, 112)
}
const DEFAULT_DECOR_SIZE := Vector2(78, 78)
const FX_SPRITES := {
	"paper": "res://assets/sprites/sprout/fx/fx-paper-sparkle.png",
	"course": "res://assets/sprites/sprout/fx/fx-course-petal.png",
	"dormant": "res://assets/sprites/sprout/fx/fx-dormant-moon.png",
	"harvested": "res://assets/sprites/sprout/fx/fx-harvest-leaf.png",
	"placement": "res://assets/sprites/sprout/fx/fx-placement-ring.png",
	"lantern": "res://assets/sprites/sprout/fx/fx-lantern-twinkle.png"
}
const DECOR_SLOTS := [
	Vector2(0.200, 0.319),
	Vector2(0.781, 0.340),
	Vector2(0.081, 0.650),
	Vector2(0.834, 0.716),
	Vector2(0.370, 0.842),
	Vector2(0.596, 0.796)
]
const PLOT_ANCHORS := {
	"active-1": Vector2(0.295, 0.471),
	"active-2": Vector2(0.500, 0.471),
	"active-3": Vector2(0.720, 0.471),
	"active-4": Vector2(0.295, 0.592),
	"active-5": Vector2(0.500, 0.592),
	"active-6": Vector2(0.720, 0.592),
	"active-7": Vector2(0.295, 0.728),
	"active-8": Vector2(0.500, 0.728),
	"active-9": Vector2(0.720, 0.728),
	"harvested-1": Vector2(0.293, 0.445),
	"harvested-2": Vector2(0.503, 0.445),
	"harvested-3": Vector2(0.719, 0.445),
	"harvested-4": Vector2(0.293, 0.590),
	"harvested-5": Vector2(0.503, 0.590),
	"harvested-6": Vector2(0.719, 0.590),
	"harvested-7": Vector2(0.293, 0.735),
	"harvested-8": Vector2(0.503, 0.735),
	"harvested-9": Vector2(0.719, 0.735),
	"dormant-1": Vector2(0.293, 0.445),
	"dormant-2": Vector2(0.503, 0.445),
	"dormant-3": Vector2(0.719, 0.445),
	"dormant-4": Vector2(0.293, 0.590),
	"dormant-5": Vector2(0.503, 0.590),
	"dormant-6": Vector2(0.719, 0.590),
	"dormant-7": Vector2(0.293, 0.735),
	"dormant-8": Vector2(0.503, 0.735),
	"dormant-9": Vector2(0.719, 0.735)
}
const PLOT_SIZE_SCALES := {
	"active-1": 0.75,
	"active-2": 0.75,
	"active-3": 0.75,
	"active-4": 0.75,
	"active-5": 0.75,
	"active-6": 0.75,
	"active-7": 0.75,
	"active-8": 0.75,
	"active-9": 1.0,
	"harvested-1": 0.75,
	"harvested-2": 0.75,
	"dormant-1": 0.75,
	"dormant-2": 0.75
}
const DECOR_ANCHORS := {
	"active": {
		"bench": Vector2(0.170, 0.822),
		"lamp": Vector2(0.835, 0.806),
		"pond": Vector2(0.705, 0.832),
		"sign": Vector2(0.148, 0.424),
		"flower-rock": Vector2(0.842, 0.620)
	},
	"harvested": {
		"well": Vector2(0.160, 0.800),
		"picnic": Vector2(0.735, 0.832),
		"path": Vector2(0.500, 0.775),
		"bench": Vector2(0.820, 0.615),
		"workbench": Vector2(0.172, 0.430)
	},
	"dormant": {
		"pond": Vector2(0.180, 0.812),
		"sign": Vector2(0.830, 0.548),
		"lamp": Vector2(0.220, 0.430),
		"flower-rock": Vector2(0.790, 0.820),
		"bridge": Vector2(0.500, 0.772)
	}
}
const ZONE_HOTSPOTS := {
	"active": [
		{"target": "harvested", "label": "收获园", "pos": Vector2(0.29, 0.15), "size": Vector2(124, 92)},
		{"target": "dormant", "label": "沉睡园", "pos": Vector2(0.70, 0.15), "size": Vector2(132, 96)}
	],
	"harvested": [
		{"target": "active", "label": "生长园", "pos": Vector2(0.29, 0.15), "size": Vector2(124, 92)},
		{"target": "dormant", "label": "沉睡园", "pos": Vector2(0.70, 0.15), "size": Vector2(132, 96)}
	],
	"dormant": [
		{"target": "active", "label": "生长园", "pos": Vector2(0.29, 0.15), "size": Vector2(124, 92)},
		{"target": "harvested", "label": "收获园", "pos": Vector2(0.70, 0.15), "size": Vector2(132, 96)}
	]
}
const STAGE_FLOW := {
	"paper": ["seed", "sapling", "tree", "flower", "fruit"],
	"course": ["sowing", "growing", "bloom", "fruit", "seed_saved"]
}
const STAGE_LABELS := {
	"seed": "种子",
	"sapling": "幼苗",
	"tree": "成树",
	"flower": "开花",
	"fruit": "结果",
	"sowing": "播种",
	"growing": "生长中",
	"bloom": "盛开",
	"seed_saved": "留种",
	"empty": "空地"
}
const NEXT_ACTION_LABELS := {
	"paper:seed": "开始阅读",
	"paper:sapling": "整理笔记",
	"paper:tree": "提交论文",
	"paper:flower": "标记接收",
	"course:sowing": "开始课程",
	"course:growing": "完成学习",
	"course:bloom": "记录成果",
	"course:fruit": "保存种子"
}
const CARE_GROWTH := {"sun": 3, "water": 4, "fertilizer": 5}
const CARE_LABELS := {"sun": "阳光", "water": "水", "fertilizer": "肥料"}
const CARE_ICON_SPRITES := {
	"sun": "res://assets/sprites/ui/care-sun-gpt-v1.png",
	"water": "res://assets/sprites/ui/care-water-gpt-v1.png",
	"fertilizer": "res://assets/sprites/ui/care-fertilizer-gpt-v1.png",
	"record": "res://assets/sprites/ui/care-record-gpt-v1.png",
	"seed": "res://assets/sprites/ui/care-seed-packet-gpt-v1.png"
}
const STATUS_LABELS := {
	"Reading": "阅读中",
	"Annotating": "批注中",
	"Practicing": "练习中",
	"Queued": "排队中",
	"Reviewing": "复盘中",
	"Captured": "已记录",
	"Consolidating": "整理中",
	"Comparing": "对比中",
	"Available": "可种植",
	"Archived": "已归档",
	"Harvested": "已丰收",
	"Published": "已发表",
	"Completed": "已完成",
	"Paused": "暂停中",
	"Waiting": "等待中",
	"Someday": "以后再说",
	"Planted": "已种下",
	"Watered": "已浇水",
	"Recorded": "已记录",
	"Fertilized": "已施肥",
	"Advanced": "已推进"
}
const TITLE_LABELS := {
	"Paper Ginkgo": "论文银杏",
	"Paper Cherry": "论文樱桃树",
	"Paper Maple": "论文枫树",
	"Paper Pine": "论文松树",
	"Paper Willow": "论文柳树",
	"Paper Camphor": "论文香樟",
	"Course Daisy": "课程雏菊",
	"Course Rose": "课程玫瑰",
	"Course Lotus": "课程莲花",
	"Course Sunflower": "课程向日葵",
	"Course Lavender": "课程薰衣草",
	"Course Hydrangea": "课程绣球",
	"Empty Plot": "空地",
	"New Paper Tree": "新的论文树",
	"New Course Flower": "新的课程花"
}
const NOTE_LABELS := {
	"A long-running paper thread with mature notes.": "这是一条长期推进的论文线索，笔记已经比较成熟。",
	"Needs a detail pass on methods and figures.": "方法和图表还需要再细看一轮。",
	"A course flower used to test non-paper projects.": "用于测试非论文项目流程的课程花。",
	"Early reading notes, not yet mature.": "早期阅读笔记，还没有完全成熟。",
	"Practice set is half finished.": "练习集完成了一半。",
	"Only a seed idea so far.": "目前还只是一个种子想法。",
	"Close to harvest, needs summary notes.": "接近丰收，还需要补总结笔记。",
	"Good candidate for a literature cluster.": "适合发展成一个文献主题簇。",
	"Tap to inspect the detail-card flow.": "点击查看详情卡片流程。",
	"Finished course notes waiting for review.": "课程笔记已完成，等待复盘。",
	"Useful references and summary cards are ready.": "有用参考和总结卡片已经整理好。",
	"Accepted paper with final summary notes.": "已接收论文，最终总结笔记已完成。",
	"Course material distilled into reusable seeds.": "课程材料已沉淀成可复用的种子。",
	"A completed reading trail with useful citations.": "完整阅读路径已沉淀出可用引用。",
	"Finished exercises and reflections.": "练习和反思已完成。",
	"Methods notes are ready for reuse.": "方法笔记已经可以复用。",
	"Small course loop closed cleanly.": "一个小课程循环已经顺利收尾。",
	"Reserved for future completed work.": "预留给未来完成的成果。",
	"A quiet project that should stay visible.": "一个暂停中的项目，仍值得保持可见。",
	"A course seed for the next study cycle.": "下一个学习周期的课程种子。",
	"Literature cluster waiting for a better moment.": "等待更合适时机重启的文献簇。",
	"Practice cycle stopped midway.": "练习周期暂时停在中途。",
	"A captured idea with no active reading yet.": "已记录的想法，还没有开始正式阅读。",
	"Course seed waiting for the next study sprint.": "等待下一轮学习冲刺的课程种子。",
	"Quiet land for parked ideas.": "用来停放想法的安静土地。",
	"Useful but not urgent.": "有用，但暂时不急。",
	"Open dormant space.": "可用于暂停项目的空地。",
	"Newly planted. Add a note when you record progress.": "刚刚种下。记录进展时可以补一条说明。"
}
const MILESTONE_GROWTH := 18
const MILESTONE_COINS := 12

var garden_data: Dictionary = {}
var selected_zone_id := "active"
var selected_plot_id := ""
var selected_decor_id := ""
var texture_cache: Dictionary = {}
var sprite_filter_shader: Shader
var animated_plot_buttons: Array[Button] = []
var animated_decor_buttons: Array[Button] = []
var animated_ambient_nodes: Array[Control] = []
var animation_time := 0.0
var debug_mode := false
var debug_selected: Dictionary = {}
var debug_dragging := false
var debug_drag_button: Control
var debug_decor_slots: Array = []
var debug_hotspots: Dictionary = {}

var root_box: VBoxContainer
var title_label: Label
var meta_label: Label
var coins_label: Label
var map_canvas: Control
var map_texture: TextureRect
var overlay_layer: Control
var hint_label: Label
var detail_panel: PanelContainer
var detail_icon: TextureRect
var detail_title: Label
var detail_meta: Label
var detail_growth_bar: ProgressBar
var detail_care_grid: GridContainer
var detail_water_value: Label
var detail_sun_value: Label
var detail_fertilizer_value: Label
var detail_note: Label
var detail_actions: GridContainer
var record_panel: PanelContainer
var record_note_input: LineEdit
var plant_panel: PanelContainer
var plant_title_label: Label
var plant_paper_button: Button
var plant_course_button: Button
var log_button: Button
var teach_button: Button
var advance_button: Button
var record_water_button: Button
var record_sun_button: Button
var record_fertilizer_button: Button
var record_note_button: Button
var sleep_button: Button
var wake_button: Button
var remove_button: Button
var decor_bar: HBoxContainer
var debug_panel: PanelContainer
var debug_title_label: Label
var debug_info_label: Label
var debug_export_label: Label
var debug_export_button: Button


func _ready() -> void:
	_load_or_seed_data()
	selected_zone_id = garden_data.get("selected_zone", "active")
	_init_debug_layout()
	_build_ui()
	call_deferred("_render_all")


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_inside_tree():
		call_deferred("_render_map")


func _process(delta: float) -> void:
	animation_time += delta
	if debug_mode:
		return
	for button in animated_plot_buttons:
		if not is_instance_valid(button):
			continue
		var phase := float(button.get_meta("phase", 0.0))
		var amount := float(button.get_meta("amount", 0.026))
		var base_position: Vector2 = button.get_meta("base_position", button.position)
		var sway := sin((animation_time + phase) * TAU * 0.34)
		button.position = base_position + Vector2(sway * 2.0, 0.0)
		button.rotation = sway * amount
	for button in animated_decor_buttons:
		if not is_instance_valid(button):
			continue
		var phase := float(button.get_meta("phase", 0.0))
		var base_position: Vector2 = button.get_meta("base_position", button.position)
		var bob := sin((animation_time + phase) * TAU * 0.18)
		var tilt := cos((animation_time + phase) * TAU * 0.12)
		button.position = base_position + Vector2(0.0, bob * 1.6)
		button.rotation = tilt * 0.012
	for node in animated_ambient_nodes:
		if not is_instance_valid(node):
			continue
		var phase := float(node.get_meta("phase", 0.0))
		var base_position: Vector2 = node.get_meta("base_position", node.position)
		var drift := sin((animation_time + phase) * TAU * 0.22)
		var flutter := cos((animation_time + phase) * TAU * 0.48)
		var travel := float(node.get_meta("travel", 1.0))
		var scale_amount := float(node.get_meta("scale_amount", 0.0))
		node.position = base_position + Vector2(drift * 8.0 * travel, flutter * 4.0 * travel)
		node.rotation = drift * 0.18
		if scale_amount > 0.0:
			var fx_scale := 1.0 + flutter * scale_amount
			node.scale = Vector2(fx_scale, fx_scale)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F2:
			_toggle_debug_mode()
		elif debug_mode and event.keycode == KEY_BRACKETLEFT:
			_adjust_selected_size(-0.05)
		elif debug_mode and event.keycode == KEY_BRACKETRIGHT:
			_adjust_selected_size(0.05)
		elif debug_mode and event.keycode == KEY_BACKSLASH:
			_export_debug_layout()
		elif debug_mode and event.keycode == KEY_ESCAPE:
			debug_selected = {}
			debug_dragging = false
			_update_debug_panel()

	if debug_mode and debug_dragging and event is InputEventMouseMotion:
		_move_debug_selected(event.position)

	if debug_mode and event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if debug_dragging:
			debug_dragging = false
			debug_drag_button = null
			_save_data()
			_update_debug_panel()


func _load_or_seed_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var saved := _read_json(SAVE_PATH)
		if saved.has("zones") and saved.has("decoration_catalog"):
			garden_data = saved
			_upgrade_saved_maps()
			_save_data()
			return

	garden_data = _read_json(SEED_PATH)
	if not garden_data.has("zones"):
		garden_data = {"zones": [], "decoration_catalog": [], "owned_decorations": {}}
	_upgrade_saved_maps()
	_save_data()


func _upgrade_saved_maps() -> void:
	var saved_layout_version := int(garden_data.get("layout_version", 0))
	var should_migrate_plot_positions := saved_layout_version < LAYOUT_VERSION
	var should_migrate_decor_positions := saved_layout_version < LAYOUT_VERSION
	for index in garden_data.get("zones", []).size():
		var zone: Dictionary = garden_data["zones"][index]
		var zone_id := str(zone.get("id", "active"))
		zone["map"] = ZONE_MAP_PATHS.get(zone_id, ZONE_MAP_PATHS["active"])
		var plots: Array = zone.get("plots", [])
		for plot_index in plots.size():
			var plot: Dictionary = plots[plot_index]
			var plot_id := str(plot.get("id", ""))
			if should_migrate_plot_positions and PLOT_ANCHORS.has(plot_id):
				var plot_anchor: Vector2 = PLOT_ANCHORS[plot_id]
				plot["x"] = plot_anchor.x
				plot["y"] = plot_anchor.y
				plot["size_scale"] = PLOT_SIZE_SCALES.get(plot_id, 1.0)
			if str(plot.get("kind", "")) == "empty":
				plot["sprite"] = EMPTY_PLOT_SIGN_SPRITE
				plot.erase("portrait_sprite")
			else:
				plot["sprite"] = _web_stage_sprite_path(plot)
				plot["portrait_sprite"] = plot["sprite"]
				if not plot.has("growth"):
					plot["growth"] = _default_growth_for_stage(plot)
				if not plot.has("care_today"):
					plot["care_today"] = {"sun": 0, "water": 0, "fertilizer": 0}
				if str(plot.get("kind", "")) == "course" and not plot.has("sessions"):
					plot["sessions"] = 0
			plots[plot_index] = plot
		zone["plots"] = plots
		var zone_decor_anchors: Dictionary = DECOR_ANCHORS.get(zone_id, {})
		var decorations: Array = zone.get("decorations", [])
		for decor_index in decorations.size():
			var placed: Dictionary = decorations[decor_index]
			var decor_id := str(placed.get("id", ""))
			if should_migrate_decor_positions and zone_decor_anchors.has(decor_id):
				var decor_anchor: Vector2 = zone_decor_anchors[decor_id]
				placed["x"] = decor_anchor.x
				placed["y"] = decor_anchor.y
				decorations[decor_index] = placed
		zone["decorations"] = decorations
		garden_data["zones"][index] = zone
	garden_data["layout_version"] = LAYOUT_VERSION


func _read_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return {}


func _save_data() -> void:
	garden_data["selected_zone"] = selected_zone_id
	garden_data["layout_version"] = LAYOUT_VERSION
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(garden_data, "\t"))


func _build_ui() -> void:
	_add_background()
	root_box = VBoxContainer.new()
	root_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_box.add_theme_constant_override("separation", 8)
	root_box.offset_left = 10
	root_box.offset_top = 10
	root_box.offset_right = -10
	root_box.offset_bottom = -10
	add_child(root_box)

	_build_header()
	_build_map()
	_build_detail_panel()
	_build_decor_bar()
	_build_debug_panel()


func _add_background() -> void:
	var background := ColorRect.new()
	background.color = Color("#d8e8b9")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)


func _build_header() -> void:
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 48)
	header.add_theme_constant_override("separation", 8)
	root_box.add_child(header)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 0)
	header.add_child(title_box)

	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.add_theme_color_override("font_color", Color("#203820"))
	title_box.add_child(title_label)

	meta_label = Label.new()
	meta_label.add_theme_font_size_override("font_size", 11)
	meta_label.add_theme_color_override("font_color", Color("#4f6545"))
	meta_label.clip_text = true
	title_box.add_child(meta_label)

	coins_label = Label.new()
	coins_label.custom_minimum_size = Vector2(82, 0)
	coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	coins_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	coins_label.add_theme_font_size_override("font_size", 14)
	coins_label.add_theme_color_override("font_color", Color("#5b3f18"))
	header.add_child(coins_label)


func _build_map() -> void:
	map_canvas = Control.new()
	map_canvas.clip_contents = true
	map_canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	map_canvas.custom_minimum_size = Vector2(0, 540)
	map_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.add_child(map_canvas)

	map_texture = TextureRect.new()
	map_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	map_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	map_canvas.add_child(map_texture)

	overlay_layer = Control.new()
	overlay_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_canvas.add_child(overlay_layer)

	hint_label = Label.new()
	hint_label.custom_minimum_size = Vector2(0, 20)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.add_theme_font_size_override("font_size", 11)
	hint_label.add_theme_color_override("font_color", Color("#365034"))
	root_box.add_child(hint_label)


func _build_detail_panel() -> void:
	detail_panel = PanelContainer.new()
	detail_panel.anchor_left = 0.0
	detail_panel.anchor_top = 1.0
	detail_panel.anchor_right = 1.0
	detail_panel.anchor_bottom = 1.0
	detail_panel.offset_left = 18
	detail_panel.offset_top = -448
	detail_panel.offset_right = -18
	detail_panel.offset_bottom = -92
	detail_panel.visible = false
	detail_panel.z_as_relative = false
	detail_panel.z_index = 1500
	detail_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(detail_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	detail_panel.add_child(box)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 8)
	box.add_child(header_row)

	var header_spacer := Control.new()
	header_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(header_spacer)

	var close_button := _corner_close_button(_close_detail)
	header_row.add_child(close_button)

	detail_icon = TextureRect.new()
	detail_icon.custom_minimum_size = Vector2(0, 132)
	detail_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	detail_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	box.add_child(detail_icon)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 1)
	row.add_child(text_box)

	detail_title = Label.new()
	detail_title.add_theme_font_size_override("font_size", 16)
	detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(detail_title)

	detail_meta = Label.new()
	detail_meta.add_theme_font_size_override("font_size", 11)
	detail_meta.add_theme_color_override("font_color", Color("#5a6c52"))
	detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(detail_meta)

	detail_growth_bar = ProgressBar.new()
	detail_growth_bar.custom_minimum_size = Vector2(0, 16)
	detail_growth_bar.max_value = 100.0
	detail_growth_bar.show_percentage = false
	box.add_child(detail_growth_bar)

	detail_care_grid = GridContainer.new()
	detail_care_grid.columns = 3
	detail_care_grid.add_theme_constant_override("h_separation", 5)
	box.add_child(detail_care_grid)

	detail_water_value = _detail_care_cell(CARE_ICON_SPRITES["water"], "水", Color("#d7f0f4"))
	detail_sun_value = _detail_care_cell(CARE_ICON_SPRITES["sun"], "阳光", Color("#fff2b8"))
	detail_fertilizer_value = _detail_care_cell(CARE_ICON_SPRITES["fertilizer"], "肥料", Color("#e6d0a4"))

	detail_note = Label.new()
	detail_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_note.add_theme_font_size_override("font_size", 12)
	detail_note.add_theme_color_override("font_color", Color("#334231"))
	box.add_child(detail_note)

	detail_actions = GridContainer.new()
	detail_actions.columns = 2
	detail_actions.add_theme_constant_override("h_separation", 6)
	detail_actions.add_theme_constant_override("v_separation", 5)
	box.add_child(detail_actions)

	log_button = _detail_action_button("记录", _on_log_pressed)
	teach_button = _detail_action_button("快速浇水", _on_teach_pressed)
	advance_button = _detail_action_button("推进阶段", _on_advance_pressed)
	sleep_button = _detail_action_button("移入睡眠园", _on_sleep_pressed)
	wake_button = _detail_action_button("唤醒", _on_wake_pressed)
	remove_button = _detail_action_button("移除", _on_remove_pressed)

	_build_record_panel()
	_build_plant_panel()
	_detail_panel_action_visibility()


func _build_decor_bar() -> void:
	var decor_panel := PanelContainer.new()
	decor_panel.custom_minimum_size = Vector2(0, 82)
	root_box.add_child(decor_panel)

	var scroller := ScrollContainer.new()
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	decor_panel.add_child(scroller)

	decor_bar = HBoxContainer.new()
	decor_bar.add_theme_constant_override("separation", 6)
	scroller.add_child(decor_bar)


func _build_debug_panel() -> void:
	debug_panel = PanelContainer.new()
	debug_panel.anchor_left = 0.0
	debug_panel.anchor_top = 0.0
	debug_panel.anchor_right = 1.0
	debug_panel.anchor_bottom = 0.0
	debug_panel.offset_left = 10
	debug_panel.offset_top = 58
	debug_panel.offset_right = -10
	debug_panel.offset_bottom = 162
	debug_panel.visible = false
	add_child(debug_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	debug_panel.add_child(box)

	debug_title_label = Label.new()
	debug_title_label.text = "Layout debug"
	debug_title_label.add_theme_font_size_override("font_size", 13)
	debug_title_label.add_theme_color_override("font_color", Color("#263522"))
	box.add_child(debug_title_label)

	debug_info_label = Label.new()
	debug_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	debug_info_label.add_theme_font_size_override("font_size", 10)
	debug_info_label.add_theme_color_override("font_color", Color("#42543c"))
	box.add_child(debug_info_label)

	debug_export_label = Label.new()
	debug_export_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	debug_export_label.add_theme_font_size_override("font_size", 10)
	debug_export_label.add_theme_color_override("font_color", Color("#6b4a1f"))
	box.add_child(debug_export_label)

	var scale_buttons := HBoxContainer.new()
	scale_buttons.add_theme_constant_override("separation", 6)
	box.add_child(scale_buttons)

	var shrink_button := Button.new()
	shrink_button.text = "All plants -"
	shrink_button.custom_minimum_size = Vector2(0, 26)
	shrink_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shrink_button.pressed.connect(_adjust_all_plot_sizes.bind(-0.05))
	scale_buttons.add_child(shrink_button)

	var grow_button := Button.new()
	grow_button.text = "All plants +"
	grow_button.custom_minimum_size = Vector2(0, 26)
	grow_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grow_button.pressed.connect(_adjust_all_plot_sizes.bind(0.05))
	scale_buttons.add_child(grow_button)

	var reset_button := Button.new()
	reset_button.text = "Reset plants"
	reset_button.custom_minimum_size = Vector2(0, 26)
	reset_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reset_button.pressed.connect(_reset_all_plot_sizes)
	scale_buttons.add_child(reset_button)

	debug_export_button = Button.new()
	debug_export_button.text = "Export layout"
	debug_export_button.custom_minimum_size = Vector2(0, 28)
	debug_export_button.pressed.connect(_export_debug_layout)
	box.add_child(debug_export_button)


func _detail_action_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 30)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _button_style(Color("#7b9b58")))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#8a8774")))
	button.pressed.connect(callable)
	detail_actions.add_child(button)
	return button


func _panel_style(fill_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 10
	style.content_margin_top = 10
	style.content_margin_right = 10
	style.content_margin_bottom = 10
	return style


func _button_style(fill_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = Color("#5c4128")
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 7
	style.corner_radius_top_right = 7
	style.corner_radius_bottom_left = 7
	style.corner_radius_bottom_right = 7
	style.content_margin_left = 6
	style.content_margin_top = 4
	style.content_margin_right = 6
	style.content_margin_bottom = 4
	return style


func _corner_close_button(callable: Callable) -> Button:
	var button := Button.new()
	button.text = "X"
	button.custom_minimum_size = Vector2(30, 26)
	button.size_flags_horizontal = Control.SIZE_SHRINK_END
	button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	button.pressed.connect(callable)
	return button


func _detail_care_cell(icon_path: String, label_text: String, icon_color: Color) -> Label:
	var cell := HBoxContainer.new()
	cell.custom_minimum_size = Vector2(0, 36)
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cell.add_theme_constant_override("separation", 4)
	detail_care_grid.add_child(cell)

	var icon_frame := PanelContainer.new()
	icon_frame.custom_minimum_size = Vector2(28, 28)
	var icon_style := StyleBoxFlat.new()
	icon_style.bg_color = icon_color
	icon_style.border_width_left = 2
	icon_style.border_width_top = 2
	icon_style.border_width_right = 2
	icon_style.border_width_bottom = 2
	icon_style.border_color = Color("#5b452b")
	icon_style.corner_radius_top_left = 5
	icon_style.corner_radius_top_right = 5
	icon_style.corner_radius_bottom_left = 5
	icon_style.corner_radius_bottom_right = 5
	icon_style.content_margin_left = 2
	icon_style.content_margin_top = 2
	icon_style.content_margin_right = 2
	icon_style.content_margin_bottom = 2
	icon_frame.add_theme_stylebox_override("panel", icon_style)
	cell.add_child(icon_frame)

	var icon := TextureRect.new()
	icon.texture = _load_texture(icon_path)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.custom_minimum_size = Vector2(24, 24)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_frame.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 0)
	cell.add_child(text_box)

	var value_label := Label.new()
	value_label.text = "0"
	value_label.add_theme_font_size_override("font_size", 13)
	value_label.add_theme_color_override("font_color", Color("#334231"))
	text_box.add_child(value_label)

	var caption := Label.new()
	caption.text = label_text
	caption.add_theme_font_size_override("font_size", 8)
	caption.add_theme_color_override("font_color", Color("#5a6c52"))
	text_box.add_child(caption)
	return value_label


func _build_record_panel() -> void:
	record_panel = PanelContainer.new()
	record_panel.anchor_left = 0.0
	record_panel.anchor_top = 1.0
	record_panel.anchor_right = 1.0
	record_panel.anchor_bottom = 1.0
	record_panel.offset_left = 24
	record_panel.offset_top = -308
	record_panel.offset_right = -24
	record_panel.offset_bottom = -98
	record_panel.visible = false
	record_panel.z_as_relative = false
	record_panel.z_index = 1600
	record_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(record_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	record_panel.add_child(box)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	var title := Label.new()
	title.text = "记录今天"
	title.add_theme_font_size_override("font_size", 14)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)

	var close_button := Button.new()
	close_button.text = "x"
	close_button.custom_minimum_size = Vector2(32, 28)
	close_button.add_theme_font_size_override("font_size", 12)
	close_button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	close_button.pressed.connect(_hide_record_panel)
	row.add_child(close_button)

	var quick_grid := GridContainer.new()
	quick_grid.columns = 3
	quick_grid.add_theme_constant_override("h_separation", 5)
	box.add_child(quick_grid)

	record_water_button = _record_button("浇水", _record_quick_water_pressed, quick_grid, CARE_ICON_SPRITES["water"])
	record_sun_button = _record_button("晒太阳", _record_quick_sun_pressed, quick_grid, CARE_ICON_SPRITES["sun"])
	record_fertilizer_button = _record_button("施肥", _record_quick_fertilizer_pressed, quick_grid, CARE_ICON_SPRITES["fertilizer"])

	record_note_input = LineEdit.new()
	record_note_input.placeholder_text = "输入一条轻量记录..."
	box.add_child(record_note_input)

	record_note_button = Button.new()
	record_note_button.text = "保存记录"
	record_note_button.custom_minimum_size = Vector2(0, 32)
	record_note_button.add_theme_font_size_override("font_size", 12)
	record_note_button.add_theme_stylebox_override("normal", _button_style(Color("#cf8d45")))
	record_note_button.pressed.connect(_record_note_pressed)
	box.add_child(record_note_button)


func _build_plant_panel() -> void:
	plant_panel = PanelContainer.new()
	plant_panel.anchor_left = 0.0
	plant_panel.anchor_top = 1.0
	plant_panel.anchor_right = 1.0
	plant_panel.anchor_bottom = 1.0
	plant_panel.offset_left = 28
	plant_panel.offset_top = -292
	plant_panel.offset_right = -28
	plant_panel.offset_bottom = -114
	plant_panel.visible = false
	plant_panel.z_as_relative = false
	plant_panel.z_index = 1500
	plant_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(plant_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	plant_panel.add_child(box)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	plant_title_label = Label.new()
	plant_title_label.text = "选择要种什么"
	plant_title_label.add_theme_font_size_override("font_size", 15)
	plant_title_label.add_theme_color_override("font_color", Color("#334231"))
	plant_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(plant_title_label)

	var close_button := _corner_close_button(_close_detail)
	row.add_child(close_button)

	var subtitle := Label.new()
	subtitle.text = "把这块空地种成论文树或课程花。"
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 10)
	subtitle.add_theme_color_override("font_color", Color("#5a6c52"))
	box.add_child(subtitle)

	var choices := GridContainer.new()
	choices.columns = 2
	choices.add_theme_constant_override("h_separation", 8)
	box.add_child(choices)

	plant_paper_button = _record_button("论文树", _plant_empty_plot.bind("paper"), choices, CARE_ICON_SPRITES["seed"])
	plant_course_button = _record_button("课程花", _plant_empty_plot.bind("course"), choices, CARE_ICON_SPRITES["seed"])


func _record_button(text: String, callable: Callable, parent: Control, icon_path := "") -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 36)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_stylebox_override("normal", _button_style(Color("#7b9b58")))
	if not str(icon_path).is_empty():
		button.icon = _load_texture(str(icon_path))
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.pressed.connect(callable)
	parent.add_child(button)
	return button


func _detail_panel_action_visibility(show_record := true, show_advance := true, show_wake := false, show_remove := false) -> void:
	if log_button != null:
		log_button.visible = show_record
	if teach_button != null:
		teach_button.visible = false
	if advance_button != null:
		advance_button.visible = show_advance
	if sleep_button != null:
		sleep_button.visible = false
	if wake_button != null:
		wake_button.visible = show_wake
	if remove_button != null:
		remove_button.visible = show_remove


func _render_all() -> void:
	_update_header()
	_render_map()
	_render_detail()
	_render_decor_bar()


func _update_header() -> void:
	var zone := _current_zone()
	title_label.text = zone.get("title", "Garden")
	meta_label.text = zone.get("subtitle", "")
	coins_label.text = "%d 枚" % int(garden_data.get("coins", 0))


func _render_map() -> void:
	if overlay_layer == null or not is_instance_valid(overlay_layer):
		return

	for child in overlay_layer.get_children():
		child.queue_free()
	animated_plot_buttons.clear()
	animated_decor_buttons.clear()
	animated_ambient_nodes.clear()

	var zone := _current_zone()
	map_texture.texture = _load_texture(zone.get("map", ""))
	await get_tree().process_frame
	var area := map_canvas.size
	if area.x <= 1 or area.y <= 1:
		return

	var map_rect := _map_rect(area)
	_render_hotspots(map_rect)
	_render_plots(map_rect, zone)
	_render_decorations(map_rect, zone)
	_render_decor_slots(map_rect)
	_update_hint()


func _render_hotspots(map_rect: Rect2) -> void:
	var hotspot_index := 0
	for hotspot in _hotspots_for_zone(selected_zone_id):
		var target := str(hotspot.get("target", "active"))
		if target == selected_zone_id:
			hotspot_index += 1
			continue

		var button := Button.new()
		var button_size: Vector2 = hotspot.get("size", Vector2(96, 72))
		button.flat = true
		button.text = ""
		button.custom_minimum_size = button_size
		button.size = button_size
		button.position = _map_point(map_rect, hotspot.get("pos", Vector2(0.5, 0.5))) - (button_size * 0.5)
		button.tooltip_text = "前往%s" % hotspot.get("label", "另一片园地")
		var item := {"type": "hotspot", "zone": selected_zone_id, "index": hotspot_index, "target": target}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_switch_zone.bind(target))
		overlay_layer.add_child(button)

		var hotspot_label := Label.new()
		hotspot_label.text = hotspot.get("label", "")
		hotspot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hotspot_label.add_theme_font_size_override("font_size", 10)
		hotspot_label.add_theme_color_override("font_color", Color("#31432c"))
		hotspot_label.add_theme_color_override("font_shadow_color", Color("#f5efd2"))
		hotspot_label.add_theme_constant_override("shadow_offset_x", 1)
		hotspot_label.add_theme_constant_override("shadow_offset_y", 1)
		hotspot_label.size = Vector2(70, 18)
		hotspot_label.position = button.position + Vector2((button_size.x - hotspot_label.size.x) * 0.5, button_size.y - 8)
		overlay_layer.add_child(hotspot_label)
		hotspot_index += 1


func _render_plots(map_rect: Rect2, zone: Dictionary) -> void:
	var plots: Array = zone.get("plots", []).duplicate()
	plots.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ay := float(a.get("y", 0.5))
		var by := float(b.get("y", 0.5))
		if not is_equal_approx(ay, by):
			return ay < by
		return float(a.get("x", 0.5)) < float(b.get("x", 0.5))
	)
	for plot in plots:
		var button := Button.new()
		var kind := str(plot.get("kind", ""))
		var button_size := _plot_button_size(plot)

		button.flat = true
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.custom_minimum_size = button_size
		button.size = button_size
		button.position = _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5))) - Vector2(button_size.x * 0.5, button_size.y * 0.82)
		button.z_index = _depth_z_index(plot)
		button.clip_text = true
		button.text = ""
		button.tooltip_text = "%s\n%s" % [_display_title(plot), _status_label(str(plot.get("status", "")))]
		var sprite_filter := _zone_sprite_filter() if kind != "empty" else {}
		_add_button_texture(button, plot.get("sprite", ""), sprite_filter)
		var item := {"type": "plot", "zone": selected_zone_id, "id": str(plot.get("id", ""))}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_select_plot.bind(plot.get("id", "")))
		overlay_layer.add_child(button)
		if kind != "empty" and not debug_mode:
			_animate_plot_button(button, plot)
			_render_plot_ambient(map_rect, plot, button_size)
		if debug_mode:
			_add_debug_tag(button, plot.get("id", "plot"))


func _render_decorations(map_rect: Rect2, zone: Dictionary) -> void:
	var decor_index := 0
	for placed in zone.get("decorations", []):
		var decor := _decor_by_id(placed.get("id", ""))
		if decor.is_empty():
			decor_index += 1
			continue
		var button := Button.new()
		var decor_scale := float(placed.get("size_scale", 1.0))
		var button_size := DEFAULT_DECOR_SIZE * decor_scale
		button.flat = true
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.custom_minimum_size = button_size
		button.size = button_size
		button.position = _map_point(map_rect, Vector2(placed.get("x", 0.5), placed.get("y", 0.5))) - Vector2(button_size.x * 0.5, button_size.y * 0.82)
		button.z_index = _depth_z_index(placed)
		button.text = ""
		button.tooltip_text = "收回%s" % decor.get("title", "装饰")
		_add_button_texture(button, decor.get("sprite", ""), _zone_sprite_filter())
		var item := {"type": "decoration", "zone": selected_zone_id, "index": decor_index, "id": str(placed.get("id", ""))}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_remove_decoration.bind(placed))
		overlay_layer.add_child(button)
		if not debug_mode:
			_animate_decor_button(button, placed)
		if debug_mode:
			_add_debug_tag(button, "%s-%d" % [placed.get("id", "decor"), decor_index])
		decor_index += 1


func _render_decor_slots(map_rect: Rect2) -> void:
	if selected_decor_id.is_empty() and not debug_mode:
		return

	for index in DECOR_SLOTS.size():
		var slot: Vector2 = _decor_slot(index)
		var button := Button.new()
		button.flat = true
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.text = "S%d" % (index + 1) if debug_mode else ""
		button.custom_minimum_size = Vector2(44, 44)
		button.size = Vector2(44, 44)
		button.position = _map_point(map_rect, slot) - Vector2(22, 34)
		button.tooltip_text = "放置选中的装饰"
		if not debug_mode:
			_add_button_texture(button, FX_SPRITES["placement"])
			button.modulate = Color(1.0, 1.0, 1.0, 0.86)
			button.set_meta("base_position", button.position)
			button.set_meta("phase", float(index) * 0.17)
			button.set_meta("travel", 0.25)
			button.set_meta("scale_amount", 0.08)
			animated_ambient_nodes.append(button)
		var item := {"type": "decor_slot", "zone": selected_zone_id, "index": index}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_place_selected_decoration.bind(index))
		overlay_layer.add_child(button)


func _render_detail() -> void:
	var plot := _selected_plot()
	detail_panel.visible = not plot.is_empty()
	if plot.is_empty():
		_hide_record_panel()
		return

	detail_icon.texture = _load_texture(plot.get("portrait_sprite", plot.get("sprite", "")))
	detail_title.text = _display_title(plot)
	var kind := str(plot.get("kind", "kind"))
	var stage := str(plot.get("stage", ""))
	detail_meta.text = "%s / %s / %s" % [
		_kind_label(kind),
		_stage_label(stage),
		_status_label(str(plot.get("status", "")))
	]
	detail_growth_bar.value = clampi(int(plot.get("growth", 0)), 0, 100)
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	detail_water_value.text = str(int(care.get("water", 0)))
	detail_sun_value.text = str(int(care.get("sun", 0)))
	detail_fertilizer_value.text = str(int(care.get("fertilizer", 0)))
	detail_note.text = _display_note(plot)
	_update_detail_actions(plot)


func _animate_plot_button(button: Button, plot: Dictionary) -> void:
	button.pivot_offset = Vector2(button.size.x * 0.5, button.size.y * 0.82)
	var stage := str(plot.get("stage", ""))
	var amount := 0.035 if stage in ["tree", "flower", "bloom", "fruit"] else 0.018
	button.set_meta("amount", amount)
	button.set_meta("phase", float(abs(str(plot.get("id", "")).hash()) % 100) / 100.0)
	button.set_meta("base_position", button.position)
	animated_plot_buttons.append(button)


func _animate_decor_button(button: Button, placed: Dictionary) -> void:
	button.pivot_offset = Vector2(button.size.x * 0.5, button.size.y * 0.82)
	button.set_meta("phase", float(abs(str(placed.get("id", "")).hash()) % 100) / 100.0)
	button.set_meta("base_position", button.position)
	animated_decor_buttons.append(button)


func _render_plot_ambient(map_rect: Rect2, plot: Dictionary, button_size: Vector2) -> void:
	var stage := str(plot.get("stage", ""))
	if not (stage in ["tree", "flower", "bloom", "fruit"]):
		return
	var origin := _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5)))
	var kind := str(plot.get("kind", ""))
	var fx_path := FX_SPRITES["paper"] if kind == "paper" else FX_SPRITES["course"]
	if selected_zone_id == "dormant":
		fx_path = FX_SPRITES["dormant"]
	elif selected_zone_id == "harvested":
		fx_path = FX_SPRITES["harvested"]
	var offsets := [Vector2(-button_size.x * 0.20, -button_size.y * 0.78), Vector2(button_size.x * 0.24, -button_size.y * 0.66)]
	for index in offsets.size():
		var mote := _make_fx_sprite(fx_path, Vector2(24, 24))
		mote.position = origin + offsets[index] - (mote.size * 0.5)
		mote.z_index = _depth_z_index(plot) + 1
		mote.set_meta("base_position", mote.position)
		mote.set_meta("phase", float((abs(str(plot.get("id", "")).hash()) + index * 37) % 100) / 100.0)
		mote.set_meta("travel", 0.55)
		mote.set_meta("scale_amount", 0.08)
		overlay_layer.add_child(mote)
		animated_ambient_nodes.append(mote)


func _render_decor_bar() -> void:
	for child in decor_bar.get_children():
		child.queue_free()

	for decor in garden_data.get("decoration_catalog", []):
		var owned := _owned_count(decor.get("id", ""))
		var button := Button.new()
		button.custom_minimum_size = Vector2(54, 64)
		button.size = Vector2(54, 64)
		button.clip_text = true
		button.text = ""
		button.disabled = owned <= 0
		button.tooltip_text = "选择%s" % decor.get("title", "装饰")
		var fill := Color("#f0d9a8") if str(decor.get("id", "")) == selected_decor_id else Color("#d8bd82")
		button.add_theme_stylebox_override("normal", _button_style(fill))
		button.add_theme_stylebox_override("disabled", _button_style(Color("#9c9275")))
		button.modulate = Color(1, 1, 1, 1) if owned > 0 else Color(0.74, 0.70, 0.62, 0.72)
		_add_button_texture(button, decor.get("sprite", ""))
		var count_label := Label.new()
		count_label.text = "x%d" % owned
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		count_label.add_theme_font_size_override("font_size", 9)
		count_label.add_theme_color_override("font_color", Color("#fff6d6"))
		count_label.add_theme_color_override("font_shadow_color", Color("#4a2f19"))
		count_label.add_theme_constant_override("shadow_offset_x", 1)
		count_label.add_theme_constant_override("shadow_offset_y", 1)
		count_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		count_label.offset_top = -16
		count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(count_label)
		button.pressed.connect(_select_decoration.bind(decor.get("id", "")))
		decor_bar.add_child(button)


func _update_hint() -> void:
	if debug_mode:
		hint_label.text = "DEBUG: drag items. [ / ] resize. \\ export. F2 exit."
	elif not selected_decor_id.is_empty():
		var decor := _decor_by_id(selected_decor_id)
		hint_label.text = "把%s放到发光的园地位置" % decor.get("title", "装饰")
	else:
		hint_label.text = "轻点植物、装饰或远处的小屋"


func _init_debug_layout() -> void:
	debug_decor_slots.clear()
	for slot in DECOR_SLOTS:
		debug_decor_slots.append(slot)

	debug_hotspots.clear()
	for zone_id in ZONE_HOTSPOTS.keys():
		var zone_hotspots: Array = []
		for hotspot in ZONE_HOTSPOTS[zone_id]:
			zone_hotspots.append({
				"target": hotspot.get("target", ""),
				"label": hotspot.get("label", ""),
				"pos": hotspot.get("pos", Vector2(0.5, 0.5)),
				"size": hotspot.get("size", Vector2(96, 72))
			})
		debug_hotspots[zone_id] = zone_hotspots


func _toggle_debug_mode() -> void:
	debug_mode = not debug_mode
	debug_selected = {}
	debug_dragging = false
	selected_decor_id = ""
	if detail_panel != null:
		detail_panel.visible = false
	if debug_panel != null:
		debug_panel.visible = debug_mode
	_render_all()
	_update_debug_panel()


func _make_debug_target(control: Control, item: Dictionary) -> void:
	control.set_meta("debug_item", item)
	control.modulate = Color(1.0, 0.96, 0.74, 0.92) if _same_debug_item(item, debug_selected) else Color(1, 1, 1, 0.86)
	control.gui_input.connect(_on_debug_target_input.bind(control, item))


func _on_debug_target_input(event: InputEvent, control: Control, item: Dictionary) -> void:
	if not debug_mode:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			debug_selected = item.duplicate(true)
			debug_dragging = true
			debug_drag_button = control
			_update_debug_panel()
			get_viewport().set_input_as_handled()


func _move_debug_selected(mouse_position: Vector2) -> void:
	if debug_selected.is_empty() or map_canvas == null:
		return

	var canvas_global := map_canvas.get_global_rect()
	var map_rect := _map_rect(map_canvas.size)
	var local_point := mouse_position - canvas_global.position
	var ratio := Vector2(
		clampf((local_point.x - map_rect.position.x) / map_rect.size.x, 0.0, 1.0),
		clampf((local_point.y - map_rect.position.y) / map_rect.size.y, 0.0, 1.0)
	)
	_set_debug_item_position(ratio)

	if debug_drag_button != null and is_instance_valid(debug_drag_button):
		var item_size := debug_drag_button.size
		debug_drag_button.position = _map_point(map_rect, ratio) - Vector2(item_size.x * 0.5, item_size.y * 0.82)
		if str(debug_selected.get("type", "")) == "hotspot":
			debug_drag_button.position = _map_point(map_rect, ratio) - (item_size * 0.5)
		elif str(debug_selected.get("type", "")) == "decor_slot":
			debug_drag_button.position = _map_point(map_rect, ratio) - Vector2(22, 34)
	_update_debug_panel()


func _set_debug_item_position(ratio: Vector2) -> void:
	var item_type := str(debug_selected.get("type", ""))
	if item_type == "plot":
		var plot := _plot_by_id(str(debug_selected.get("id", "")))
		if not plot.is_empty():
			plot["x"] = snappedf(ratio.x, 0.001)
			plot["y"] = snappedf(ratio.y, 0.001)
	elif item_type == "decoration":
		var decoration := _decoration_by_index(int(debug_selected.get("index", -1)))
		if not decoration.is_empty():
			decoration["x"] = snappedf(ratio.x, 0.001)
			decoration["y"] = snappedf(ratio.y, 0.001)
	elif item_type == "decor_slot":
		_set_decor_slot(int(debug_selected.get("index", -1)), ratio)
	elif item_type == "hotspot":
		var hotspot := _hotspot_by_index(str(debug_selected.get("zone", selected_zone_id)), int(debug_selected.get("index", -1)))
		if not hotspot.is_empty():
			hotspot["pos"] = Vector2(snappedf(ratio.x, 0.001), snappedf(ratio.y, 0.001))


func _adjust_selected_size(delta: float) -> void:
	if debug_selected.is_empty():
		return
	var item_type := str(debug_selected.get("type", ""))
	if item_type == "plot":
		var plot := _plot_by_id(str(debug_selected.get("id", "")))
		if not plot.is_empty():
			plot["size_scale"] = clampf(float(plot.get("size_scale", 1.0)) + delta, 0.45, 2.0)
	elif item_type == "decoration":
		var decoration := _decoration_by_index(int(debug_selected.get("index", -1)))
		if not decoration.is_empty():
			decoration["size_scale"] = clampf(float(decoration.get("size_scale", 1.0)) + delta, 0.45, 2.0)
	elif item_type == "hotspot":
		var hotspot := _hotspot_by_index(str(debug_selected.get("zone", selected_zone_id)), int(debug_selected.get("index", -1)))
		if not hotspot.is_empty():
			var hotspot_size: Vector2 = hotspot.get("size", Vector2(96, 72))
			var amount := 12.0 if delta > 0.0 else -12.0
			hotspot["size"] = Vector2(maxf(24.0, hotspot_size.x + amount), maxf(24.0, hotspot_size.y + amount))
	else:
		return
	_save_data()
	_render_map()
	_update_debug_panel()


func _adjust_all_plot_sizes(delta: float) -> void:
	for zone_index in garden_data.get("zones", []).size():
		var zone: Dictionary = garden_data["zones"][zone_index]
		var plots: Array = zone.get("plots", [])
		for plot_index in plots.size():
			var plot: Dictionary = plots[plot_index]
			if str(plot.get("kind", "")) == "empty":
				continue
			plot["size_scale"] = clampf(float(plot.get("size_scale", 1.0)) + delta, 0.45, 1.5)
			plots[plot_index] = plot
		zone["plots"] = plots
		garden_data["zones"][zone_index] = zone
	_save_data()
	_render_map()
	_update_debug_panel()


func _reset_all_plot_sizes() -> void:
	for zone_index in garden_data.get("zones", []).size():
		var zone: Dictionary = garden_data["zones"][zone_index]
		var plots: Array = zone.get("plots", [])
		for plot_index in plots.size():
			var plot: Dictionary = plots[plot_index]
			if str(plot.get("kind", "")) == "empty":
				continue
			plot["size_scale"] = 1.0
			plots[plot_index] = plot
		zone["plots"] = plots
		garden_data["zones"][zone_index] = zone
	_save_data()
	_render_map()
	_update_debug_panel()


func _export_debug_layout() -> void:
	var export := {
		"selected_zone": selected_zone_id,
		"plots": [],
		"decorations": [],
		"decor_slots": [],
		"hotspots": debug_hotspots
	}
	for zone in garden_data.get("zones", []):
		for plot in zone.get("plots", []):
			export["plots"].append({
				"zone": zone.get("id", ""),
				"id": plot.get("id", ""),
				"x": plot.get("x", 0.5),
				"y": plot.get("y", 0.5),
				"size_scale": plot.get("size_scale", 1.0)
			})
		var index := 0
		for decoration in zone.get("decorations", []):
			export["decorations"].append({
				"zone": zone.get("id", ""),
				"index": index,
				"id": decoration.get("id", ""),
				"x": decoration.get("x", 0.5),
				"y": decoration.get("y", 0.5),
				"size_scale": decoration.get("size_scale", 1.0)
			})
			index += 1
	for index in debug_decor_slots.size():
		var slot: Vector2 = debug_decor_slots[index]
		export["decor_slots"].append({"index": index, "x": slot.x, "y": slot.y})

	var file := FileAccess.open(DEBUG_EXPORT_PATH, FileAccess.WRITE)
	if file != null:
		var export_text := JSON.stringify(_debug_export_to_jsonable(export), "\t")
		file.store_string(export_text)
		var project_file := FileAccess.open(DEBUG_EXPORT_PROJECT_PATH, FileAccess.WRITE)
		if project_file != null:
			project_file.store_string(export_text)
		debug_export_label.text = "Exported: %s" % ProjectSettings.globalize_path(DEBUG_EXPORT_PROJECT_PATH)
	_update_debug_panel()


func _debug_export_to_jsonable(value: Variant) -> Variant:
	if typeof(value) == TYPE_VECTOR2:
		return {"x": value.x, "y": value.y}
	if typeof(value) == TYPE_ARRAY:
		var result: Array = []
		for item in value:
			result.append(_debug_export_to_jsonable(item))
		return result
	if typeof(value) == TYPE_DICTIONARY:
		var result := {}
		for key in value.keys():
			result[key] = _debug_export_to_jsonable(value[key])
		return result
	return value


func _update_debug_panel() -> void:
	if debug_panel == null:
		return
	debug_panel.visible = debug_mode
	if not debug_mode:
		return
	if debug_selected.is_empty():
		debug_info_label.text = "F2 exit. Drag an item. [ / ] resize selected. \\ export layout."
		return
	var info := _debug_selected_info()
	debug_info_label.text = info


func _debug_selected_info() -> String:
	var item_type := str(debug_selected.get("type", ""))
	if item_type == "plot":
		var plot := _plot_by_id(str(debug_selected.get("id", "")))
		return "Plot %s  x %.3f  y %.3f  scale %.2f" % [plot.get("id", ""), plot.get("x", 0.0), plot.get("y", 0.0), plot.get("size_scale", 1.0)]
	if item_type == "decoration":
		var decoration := _decoration_by_index(int(debug_selected.get("index", -1)))
		return "Decor %s[%d]  x %.3f  y %.3f  scale %.2f" % [decoration.get("id", ""), int(debug_selected.get("index", -1)), decoration.get("x", 0.0), decoration.get("y", 0.0), decoration.get("size_scale", 1.0)]
	if item_type == "decor_slot":
		var slot := _decor_slot(int(debug_selected.get("index", -1)))
		return "Decor slot %d  x %.3f  y %.3f" % [int(debug_selected.get("index", -1)) + 1, slot.x, slot.y]
	if item_type == "hotspot":
		var hotspot := _hotspot_by_index(str(debug_selected.get("zone", selected_zone_id)), int(debug_selected.get("index", -1)))
		var pos: Vector2 = hotspot.get("pos", Vector2.ZERO)
		var hotspot_size: Vector2 = hotspot.get("size", Vector2.ZERO)
		return "Hotspot %s  x %.3f  y %.3f  w %.0f  h %.0f" % [hotspot.get("target", ""), pos.x, pos.y, hotspot_size.x, hotspot_size.y]
	return "Selected: %s" % item_type


func _add_debug_tag(target: Control, text: String) -> void:
	var tag := Label.new()
	tag.text = text
	tag.add_theme_font_size_override("font_size", 8)
	tag.add_theme_color_override("font_color", Color("#1f2b1d"))
	tag.add_theme_color_override("font_shadow_color", Color("#fff3b0"))
	tag.add_theme_constant_override("shadow_offset_x", 1)
	tag.add_theme_constant_override("shadow_offset_y", 1)
	tag.position = target.position + Vector2(0, -12)
	tag.size = Vector2(92, 14)
	overlay_layer.add_child(tag)


func _same_debug_item(a: Dictionary, b: Dictionary) -> bool:
	if a.is_empty() or b.is_empty():
		return false
	return str(a.get("type", "")) == str(b.get("type", "")) and str(a.get("id", a.get("index", ""))) == str(b.get("id", b.get("index", ""))) and str(a.get("zone", selected_zone_id)) == str(b.get("zone", selected_zone_id))


func _switch_zone(zone_id: String) -> void:
	selected_zone_id = zone_id
	selected_decor_id = ""
	selected_plot_id = ""
	_hide_record_panel()
	_hide_plant_panel()
	_save_data()
	_render_all()


func _select_plot(plot_id: String) -> void:
	selected_plot_id = plot_id
	selected_decor_id = ""
	_hide_record_panel()
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return
	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				_save_data()
				_show_plant_panel()
				call_deferred("_render_map")
				return
			_hide_plant_panel()
			plots[index]["visits"] = int(plots[index].get("visits", 0)) + 1
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_render_detail()
	call_deferred("_render_map")


func _close_detail() -> void:
	selected_plot_id = ""
	if detail_panel != null:
		detail_panel.visible = false
	_hide_record_panel()
	_hide_plant_panel()
	call_deferred("_render_map")


func _on_log_pressed() -> void:
	_show_record_panel()


func _on_teach_pressed() -> void:
	_record_care("water", "Teaching logged")


func _show_record_panel() -> void:
	if record_panel == null:
		return
	_hide_plant_panel()
	record_panel.visible = not selected_plot_id.is_empty()
	if record_note_input != null:
		record_note_input.text = ""


func _hide_record_panel() -> void:
	if record_panel != null:
		record_panel.visible = false


func _show_plant_panel() -> void:
	if plant_panel == null:
		return
	if detail_panel != null:
		detail_panel.visible = false
	_hide_record_panel()
	var plot := _selected_plot()
	plant_title_label.text = "在%s种植" % _display_title(plot)
	plant_panel.visible = not selected_plot_id.is_empty()


func _hide_plant_panel() -> void:
	if plant_panel != null:
		plant_panel.visible = false


func _plant_empty_plot(kind: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") != selected_plot_id:
			continue
		var plot: Dictionary = plots[index]
		if str(plot.get("kind", "")) != "empty":
			return
		plot["kind"] = kind
		plot["stage"] = "seed" if kind == "paper" else "sowing"
		plot["title"] = "New Paper Tree" if kind == "paper" else "New Course Flower"
		plot["status"] = "Planted"
		plot["note"] = "Newly planted. Add a note when you record progress."
		plot["growth"] = 0
		plot["visits"] = 0
		plot["logs"] = 0
		plot["care_today"] = {"sun": 0, "water": 0, "fertilizer": 0}
		if kind == "course":
			plot["sessions"] = 0
		var file_base := "paper-ginkgo-seed" if kind == "paper" else "course-daisy-sowing"
		plot["sprite"] = _web_stage_file_path(file_base)
		plot["portrait_sprite"] = plot["sprite"]
		plots[index] = plot
		garden_data["zones"][zone_index]["plots"] = plots
		break
	_save_data()
	_hide_plant_panel()
	_render_all()


func _record_quick_water_pressed() -> void:
	_record_care("water", "Watered")


func _record_quick_sun_pressed() -> void:
	_record_care("sun", "Recorded")


func _record_quick_fertilizer_pressed() -> void:
	_record_care("fertilizer", "Fertilized")


func _record_note_pressed() -> void:
	if record_note_input == null or record_note_input.text.strip_edges().is_empty():
		_record_care("sun", "Recorded")
		return
	_record_note(record_note_input.text.strip_edges())


func _record_care(care_type: String, status_text: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = status_text
			plots[index]["growth"] = int(plots[index].get("growth", 0)) + int(CARE_GROWTH.get(care_type, 0))
			var care: Dictionary = plots[index].get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
			care[care_type] = int(care.get(care_type, 0)) + 1
			plots[index]["care_today"] = care
			if str(plots[index].get("kind", "")) == "course" and care_type == "water":
				plots[index]["sessions"] = int(plots[index].get("sessions", 0)) + 1
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_hide_record_panel()
	_render_detail()
	call_deferred("_render_map")


func _record_note(note_text: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = "Note saved"
			plots[index]["note"] = note_text
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_hide_record_panel()
	_render_detail()
	call_deferred("_render_map")


func _on_advance_pressed() -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") != selected_plot_id:
			continue
		var plot: Dictionary = plots[index]
		var kind := str(plot.get("kind", ""))
		if kind == "empty":
			return
		var next_stage := _next_stage(plot)
		if next_stage.is_empty():
			return
		plot["stage"] = next_stage
		plot["growth"] = int(plot.get("growth", 0)) + MILESTONE_GROWTH
		garden_data["coins"] = int(garden_data.get("coins", 0)) + MILESTONE_COINS
		_set_plot_stage_sprites(plot)
		if _is_final_stage(plot):
			plot["status"] = "Harvested"
			_move_plot_to_zone(plot, zone_index, "harvested")
		else:
			plot["status"] = "Advanced"
			plots[index] = plot
			garden_data["zones"][zone_index]["plots"] = plots
		break
	_save_data()
	_render_all()


func _on_sleep_pressed() -> void:
	_move_selected_plot_status("dormant", "Paused")


func _on_wake_pressed() -> void:
	_move_selected_plot_status("active", "Waking")


func _on_remove_pressed() -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id and str(plots[index].get("kind", "")) != "empty":
			plots.remove_at(index)
			break
	garden_data["zones"][zone_index]["plots"] = plots
	selected_plot_id = ""
	_hide_record_panel()
	_hide_plant_panel()
	_save_data()
	_render_all()


func _select_decoration(decor_id: String) -> void:
	selected_plot_id = ""
	selected_decor_id = decor_id
	_hide_record_panel()
	_hide_plant_panel()
	_render_detail()
	call_deferred("_render_map")


func _place_selected_decoration(slot_index: int) -> void:
	if selected_decor_id.is_empty() or _owned_count(selected_decor_id) <= 0:
		return

	var zone_index := _current_zone_index()
	if zone_index < 0:
		return

	var slot: Vector2 = DECOR_SLOTS[slot_index]
	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	decorations.append({"id": selected_decor_id, "x": slot.x, "y": slot.y})
	garden_data["zones"][zone_index]["decorations"] = decorations
	garden_data["owned_decorations"][selected_decor_id] = _owned_count(selected_decor_id) - 1
	selected_decor_id = ""
	_save_data()
	_render_all()


func _remove_decoration(placed: Dictionary) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return

	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	for index in decorations.size():
		if decorations[index] == placed:
			var decor_id: String = placed.get("id", "")
			decorations.remove_at(index)
			garden_data["owned_decorations"][decor_id] = _owned_count(decor_id) + 1
			break
	garden_data["zones"][zone_index]["decorations"] = decorations
	selected_decor_id = ""
	_save_data()
	_render_all()


func _move_selected_plot_status(target_zone_id: String, status_text: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") != selected_plot_id:
			continue
		var plot: Dictionary = plots[index]
		if str(plot.get("kind", "")) == "empty" or selected_zone_id == target_zone_id:
			return
		plot["status"] = status_text
		_move_plot_to_zone(plot, zone_index, target_zone_id)
		break
	_save_data()
	_render_all()


func _move_plot_to_zone(plot: Dictionary, source_zone_index: int, target_zone_id: String) -> void:
	var target_zone_index := _zone_index_by_id(target_zone_id)
	if source_zone_index < 0 or target_zone_index < 0:
		return

	var source_plots: Array = garden_data["zones"][source_zone_index].get("plots", [])
	for index in source_plots.size():
		if source_plots[index].get("id", "") == plot.get("id", ""):
			source_plots.remove_at(index)
			break
	garden_data["zones"][source_zone_index]["plots"] = source_plots

	var target_plots: Array = garden_data["zones"][target_zone_index].get("plots", [])
	plot["id"] = _next_zone_plot_id(target_zone_id, target_plots)
	var anchor: Vector2 = PLOT_ANCHORS.get(plot["id"], Vector2(0.5, 0.64))
	plot["x"] = anchor.x
	plot["y"] = anchor.y
	target_plots.append(plot)
	garden_data["zones"][target_zone_index]["plots"] = target_plots
	selected_zone_id = target_zone_id
	selected_plot_id = plot["id"]
	selected_decor_id = ""


func _zone_index_by_id(zone_id: String) -> int:
	var zones: Array = garden_data.get("zones", [])
	for index in zones.size():
		if zones[index].get("id", "") == zone_id:
			return index
	return -1


func _next_zone_plot_id(zone_id: String, plots: Array) -> String:
	var used := {}
	for plot in plots:
		used[str(plot.get("id", ""))] = true
	for index in range(1, 10):
		var candidate := "%s-%d" % [zone_id, index]
		if not used.has(candidate):
			return candidate
	return "%s-%d" % [zone_id, plots.size() + 1]


func _update_detail_actions(plot: Dictionary) -> void:
	var kind := str(plot.get("kind", ""))
	var is_empty := kind == "empty"
	var is_active := selected_zone_id == "active"
	var is_dormant := selected_zone_id == "dormant"
	log_button.text = "记录"
	teach_button.text = "快捷%s" % CARE_LABELS.get("water", "水")
	advance_button.text = _next_action_label(plot)
	sleep_button.text = "移入睡眠园"
	wake_button.text = "唤醒"
	remove_button.text = "移除"
	log_button.disabled = is_empty or not is_active
	teach_button.disabled = is_empty or kind != "course" or not is_active
	advance_button.disabled = is_empty or not is_active or _next_stage(plot).is_empty()
	sleep_button.disabled = is_empty or not is_active
	wake_button.disabled = is_empty or not is_dormant
	remove_button.disabled = is_empty
	_detail_panel_action_visibility(is_active and not is_empty, is_active and not is_empty, is_dormant and not is_empty, not is_empty and not is_active)
	if is_empty:
		log_button.text = "稍后种植"
		teach_button.text = "选择类型"
		advance_button.text = "暂无阶段"
		sleep_button.text = "预留"
		wake_button.text = "预留"
		remove_button.text = "空地"
		_detail_panel_action_visibility(false, false, false, false)


func _kind_label(kind: String) -> String:
	if kind == "paper":
		return "论文树"
	if kind == "course":
		return "课程花"
	if kind == "empty":
		return "空地"
	return kind.capitalize()


func _stage_label(stage: String) -> String:
	return STAGE_LABELS.get(stage, stage.capitalize())


func _status_label(status: String) -> String:
	return STATUS_LABELS.get(status, status)


func _display_title(plot: Dictionary) -> String:
	var title := str(plot.get("title", ""))
	return TITLE_LABELS.get(title, title)


func _display_note(plot: Dictionary) -> String:
	var note := str(plot.get("note", ""))
	return NOTE_LABELS.get(note, note)


func _care_line(plot: Dictionary) -> String:
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	return "今日：阳光 %d / 水 %d / 肥料 %d" % [
		int(care.get("sun", 0)),
		int(care.get("water", 0)),
		int(care.get("fertilizer", 0))
	]


func _next_action_label(plot: Dictionary) -> String:
	var key := "%s:%s" % [plot.get("kind", ""), plot.get("stage", "")]
	return NEXT_ACTION_LABELS.get(key, "推进阶段")


func _next_stage(plot: Dictionary) -> String:
	var kind := str(plot.get("kind", ""))
	var stage := str(plot.get("stage", ""))
	var flow: Array = STAGE_FLOW.get(kind, [])
	var index := flow.find(stage)
	if index < 0 or index >= flow.size() - 1:
		return ""
	return str(flow[index + 1])


func _is_final_stage(plot: Dictionary) -> bool:
	var kind := str(plot.get("kind", ""))
	var flow: Array = STAGE_FLOW.get(kind, [])
	return flow.size() > 0 and str(plot.get("stage", "")) == str(flow[flow.size() - 1])


func _set_plot_stage_sprites(plot: Dictionary) -> void:
	var base := _plant_variety_base(plot)
	if base.is_empty():
		return
	var stage := str(plot.get("stage", ""))
	var file_base := "%s-%s" % [base, stage]
	plot["sprite"] = _web_stage_file_path(file_base)
	plot["portrait_sprite"] = plot["sprite"]


func _plant_variety_base(plot: Dictionary) -> String:
	var kind := str(plot.get("kind", ""))
	if kind.is_empty() or kind == "empty":
		return ""
	var file_name := str(plot.get("sprite", "")).get_file().get_basename()
	if file_name.ends_with("-rebuilt"):
		file_name = file_name.trim_suffix("-rebuilt")
	if file_name.ends_with("-full"):
		file_name = file_name.trim_suffix("-full")
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


func _default_growth_for_stage(plot: Dictionary) -> int:
	var kind := str(plot.get("kind", ""))
	var flow: Array = STAGE_FLOW.get(kind, [])
	var index := flow.find(str(plot.get("stage", "")))
	return maxi(index, 0) * MILESTONE_GROWTH


func _current_zone() -> Dictionary:
	for zone in garden_data.get("zones", []):
		if zone.get("id", "") == selected_zone_id:
			return zone
	var zones: Array = garden_data.get("zones", [])
	return zones[0] if zones.size() > 0 else {}


func _current_zone_index() -> int:
	var zones: Array = garden_data.get("zones", [])
	for index in zones.size():
		if zones[index].get("id", "") == selected_zone_id:
			return index
	return -1


func _selected_plot() -> Dictionary:
	if selected_plot_id.is_empty():
		return {}
	for plot in _current_zone().get("plots", []):
		if plot.get("id", "") == selected_plot_id:
			return plot
	return {}


func _decor_by_id(decor_id: String) -> Dictionary:
	for decor in garden_data.get("decoration_catalog", []):
		if decor.get("id", "") == decor_id:
			return decor
	return {}


func _owned_count(decor_id: String) -> int:
	return int(garden_data.get("owned_decorations", {}).get(decor_id, 0))


func _plot_by_id(plot_id: String) -> Dictionary:
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return {}
	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if str(plots[index].get("id", "")) == plot_id:
			return plots[index]
	return {}


func _decoration_by_index(index: int) -> Dictionary:
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return {}
	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	if index < 0 or index >= decorations.size():
		return {}
	return decorations[index]


func _plot_button_size(plot: Dictionary) -> Vector2:
	var kind := str(plot.get("kind", "course"))
	var stage := str(plot.get("stage", ""))
	var stage_key := "%s:%s" % [kind, stage]
	var base: Vector2 = STAGE_PLOT_SIZES.get(stage_key, DEFAULT_PLOT_SIZES.get(kind, DEFAULT_PLOT_SIZES["course"]))
	return base * float(plot.get("size_scale", 1.0))


func _depth_z_index(item: Dictionary) -> int:
	return int(round(float(item.get("y", 0.5)) * 1000.0))


func _decor_slot(index: int) -> Vector2:
	if index >= 0 and index < debug_decor_slots.size():
		return debug_decor_slots[index]
	if index >= 0 and index < DECOR_SLOTS.size():
		return DECOR_SLOTS[index]
	return Vector2(0.5, 0.5)


func _set_decor_slot(index: int, value: Vector2) -> void:
	if index < 0:
		return
	while debug_decor_slots.size() <= index:
		debug_decor_slots.append(Vector2(0.5, 0.5))
	debug_decor_slots[index] = Vector2(snappedf(value.x, 0.001), snappedf(value.y, 0.001))


func _hotspots_for_zone(zone_id: String) -> Array:
	if debug_hotspots.has(zone_id):
		return debug_hotspots[zone_id]
	return ZONE_HOTSPOTS.get(zone_id, [])


func _hotspot_by_index(zone_id: String, index: int) -> Dictionary:
	var hotspots := _hotspots_for_zone(zone_id)
	if index < 0 or index >= hotspots.size():
		return {}
	return hotspots[index]


func _map_rect(area: Vector2) -> Rect2:
	var rect_size: Vector2 = area
	var area_aspect: float = area.x / maxf(area.y, 1.0)
	if area_aspect > MAP_DISPLAY_ASPECT:
		rect_size.y = area.x / MAP_DISPLAY_ASPECT
	else:
		rect_size.x = area.y * MAP_DISPLAY_ASPECT
	return Rect2((area - rect_size) * 0.5, rect_size)


func _map_point(map_rect: Rect2, ratio: Vector2) -> Vector2:
	return map_rect.position + Vector2(map_rect.size.x * ratio.x, map_rect.size.y * ratio.y)


func _load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if texture_cache.has(path):
		return texture_cache[path]

	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		return null

	var texture := ImageTexture.create_from_image(image)
	texture_cache[path] = texture
	return texture


func _add_button_texture(button: Button, path: String, sprite_filter := {}) -> void:
	var icon := TextureRect.new()
	icon.texture = _load_texture(path)
	icon.material = _sprite_filter_material(sprite_filter)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	button.add_child(icon)


func _make_fx_sprite(path: String, target_size: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = _load_texture(path)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = target_size
	icon.size = target_size
	icon.pivot_offset = target_size * 0.5
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon


func _zone_sprite_filter() -> Dictionary:
	return ZONE_SPRITE_FILTERS.get(selected_zone_id, ZONE_SPRITE_FILTERS["active"])


func _sprite_filter_material(sprite_filter: Dictionary) -> Material:
	var strength := float(sprite_filter.get("strength", 0.0))
	var brightness := float(sprite_filter.get("brightness", 1.0))
	if strength <= 0.0 and is_equal_approx(brightness, 1.0):
		return null
	if sprite_filter_shader == null:
		sprite_filter_shader = Shader.new()
		sprite_filter_shader.code = "shader_type canvas_item;\nuniform vec4 filter_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);\nuniform float filter_strength = 0.0;\nuniform float filter_brightness = 1.0;\nvoid fragment() {\n\tvec4 tex = texture(TEXTURE, UV);\n\tvec3 filtered = mix(tex.rgb, filter_color.rgb, filter_strength) * filter_brightness;\n\tCOLOR = vec4(filtered, tex.a);\n}\n"
	var shader_material := ShaderMaterial.new()
	shader_material.shader = sprite_filter_shader
	shader_material.set_shader_parameter("filter_color", sprite_filter.get("color", Color.WHITE))
	shader_material.set_shader_parameter("filter_strength", strength)
	shader_material.set_shader_parameter("filter_brightness", brightness)
	return shader_material


func _web_stage_sprite_path(plot: Dictionary) -> String:
	var base := _plant_variety_base(plot)
	if base.is_empty():
		return str(plot.get("sprite", ""))
	return _web_stage_file_path("%s-%s" % [base, str(plot.get("stage", ""))])


func _web_stage_file_path(file_base: String) -> String:
	var normalized_path := "res://assets/sprites/web-normalized-stages/%s.png" % file_base
	if FileAccess.file_exists(normalized_path):
		return normalized_path
	var full_path := "res://assets/sprites/stages/%s-full.png" % file_base
	if FileAccess.file_exists(full_path):
		return full_path
	return "res://assets/sprites/stages/%s.png" % file_base


func _plant_sprite_base(path: String) -> String:
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
