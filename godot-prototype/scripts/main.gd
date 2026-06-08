extends Control

const SAVE_PATH := "user://garden_state.json"
const IMPORT_BACKUP_PATH := "user://garden_state.before-import.json"
const SAVE_SCHEMA_VERSION := 1
const EXPORT_FILE_NAME := "academic-garden-save.json"
const SEED_PATH := "res://data/garden_seed.json"
const DEBUG_EXPORT_PATH := "user://layout_debug_export.json"
const DEBUG_EXPORT_PROJECT_PATH := "res://layout_debug_export.json"
const LAYOUT_VERSION := 23
const MAP_DISPLAY_ASPECT := 780.0 / 1240.0
const ROOT_MARGIN_PX := 10.0
const APP_BACKGROUND_SPRITE := "res://assets/sprites/ui/app-wood-bg-v1.png"
const TITLE_LOGO_SPRITE := "res://assets/sprites/ui/academic-garden-logo-gpt-v1.png"
const COIN_ICON_SPRITE := "res://assets/sprites/coin-v1.png"
const EMPTY_PLOT_SIGN_SPRITE := "res://assets/sprites/sprout/ground/plot-soil-gpt-v3.png"
const DR_MEOW_SPRITE := "res://assets/sprites/ui/dr-meow-guide-gpt-v1.png"
const MAIN_BGM_STREAM := "res://assets/audio/garden_bgm_main_loop.wav"
const DORMANT_BGM_STREAM := "res://assets/audio/garden_bgm_dormant_loop.wav"
const BGM_VOLUME_DB := -15.0
const DORMANT_BGM_VOLUME_DB := -17.0
const MUTED_VOLUME_DB := -80.0
const ONBOARDING_Z_INDEX := 1900
const ZONE_MAP_PATHS := {
	"active": "res://assets/sprites/sprout/maps/sprout-map-active-gpt-v4-noplot-tallfield.png",
	"harvested": "res://assets/sprites/sprout/maps/sprout-map-harvested-gpt-v6-structural.png",
	"dormant": "res://assets/sprites/sprout/maps/sprout-map-dormant-gpt-v6-structural.png"
}
const ZONE_SPRITE_FILTERS := {
	"active": {"color": Color(1.0, 1.0, 1.0, 1.0), "strength": 0.0, "brightness": 1.0},
	"harvested": {"color": Color(1.0, 0.82, 0.42, 1.0), "strength": 0.18, "brightness": 1.04},
	"dormant": {"color": Color(0.31, 0.43, 0.54, 1.0), "strength": 0.48, "brightness": 0.82}
}
const DEFAULT_PLOT_SIZES := {
	"paper": Vector2(96, 108),
	"course": Vector2(88, 98),
	"empty": Vector2(96, 74)
}
const STAGE_PLOT_SIZES := {
	"paper:seed": Vector2(52, 56),
	"paper:sapling": Vector2(68, 88),
	"paper:tree": Vector2(132, 158),
	"paper:flower": Vector2(132, 158),
	"paper:fruit": Vector2(132, 158),
	"course:sowing": Vector2(50, 56),
	"course:growing": Vector2(82, 102),
	"course:bloom": Vector2(106, 128),
	"course:fruit": Vector2(106, 128),
	"course:seed_saved": Vector2(106, 128)
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
	"active-1": 0.76,
	"active-2": 0.76,
	"active-3": 0.76,
	"active-4": 0.84,
	"active-5": 0.84,
	"active-6": 0.84,
	"active-7": 0.92,
	"active-8": 0.92,
	"active-9": 1.0,
	"harvested-1": 0.72,
	"harvested-2": 0.72,
	"harvested-3": 0.72,
	"harvested-4": 0.82,
	"harvested-5": 0.82,
	"harvested-6": 0.82,
	"harvested-7": 0.90,
	"harvested-8": 0.90,
	"harvested-9": 0.96,
	"dormant-1": 0.82,
	"dormant-2": 0.82,
	"dormant-3": 0.82,
	"dormant-4": 0.92,
	"dormant-5": 0.92,
	"dormant-6": 0.92,
	"dormant-7": 1.0,
	"dormant-8": 1.0,
	"dormant-9": 1.0
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
const QUICK_RECORD_SLOT_COUNT := 3
const QUICK_RECORD_DEFAULTS := {
	"paper": ["更新文稿", "进行讨论", "阅读文献"],
	"course": ["备课", "上课", "批改作业"],
	"default": ["记录进展", "进行讨论", "整理笔记"]
}
const ONBOARDING_STEPS := [
	{
		"target": "guide_button",
		"title": "喵博士报到",
		"body": "我是 Dr.Meow，负责带你逛第一圈。学术花园把论文、课程和想法种成植物：轻点、记录、推进，它们就会从种子长成成果。"
	},
	{
		"target": "map",
		"title": "先看地图",
		"body": "这里是当前园地。植物代表正在推进的学术事项，装饰代表你已经拥有的布置素材；轻点植物可以查看详情。"
	},
	{
		"target": "hotspot",
		"title": "三个界面的定位",
		"body": "生长园放正在做的事，收获园放已完成或可复用的成果，沉睡园放暂停但不想忘记的项目。点地图上方木牌就能切换。"
	},
	{
		"target": "plot",
		"title": "每棵植物是一条记录线",
		"body": "论文树适合论文、文献簇和方法线索；课程花适合课程、练习和教学循环。空地可以种新的论文树或课程花。"
	},
	{
		"target": "detail",
		"title": "详情卡怎么看",
		"body": "详情卡会显示类型、阶段、状态、成长值和今日照料。用“推进阶段”记录重要里程碑，用“记录”写下今天发生了什么。"
	},
	{
		"target": "record",
		"title": "怎样记录",
		"body": "记录面板有三个可自定义快捷按钮，也可以输入一条轻量笔记。保存后会进入该植物的记录历史，并同步进本地存档。"
	},
	{
		"target": "decor",
		"title": "装饰、备份和重看",
		"body": "底部托盘可以选择装饰并放到发光位置。右上角备份用于导出/导入存档；以后点“新手引导”，我会再讲一遍。"
	}
]
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
var animated_ambient_nodes: Array[Control] = []
var animated_stage_textures: Array[TextureRect] = []
var plant_feedback_by_id: Dictionary = {}
var animation_time := 0.0
var debug_mode := false
var debug_selected: Dictionary = {}
var debug_dragging := false
var debug_drag_button: Control
var debug_decor_slots: Array = []
var debug_hotspots: Dictionary = {}
var music_player: AudioStreamPlayer
var music_tween: Tween
var current_music_stream := ""

var root_box: VBoxContainer
var title_logo: TextureRect
var title_label: Label
var meta_label: Label
var coins_icon: TextureRect
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
var record_quick_buttons: Array = []
var record_quick_label_inputs: Array = []
var record_quick_save_button: Button
var record_history_panel: PanelContainer
var record_history_text: Label
var plant_panel: PanelContainer
var plant_title_label: Label
var plant_paper_button: Button
var plant_course_button: Button
var guide_button: Button
var backup_button: Button
var backup_panel: PanelContainer
var backup_status_label: Label
var export_dialog: FileDialog
var import_dialog: FileDialog
var log_button: Button
var history_button: Button
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
var runtime_layout_logged := false
var onboarding_overlay: Control
var onboarding_highlight: PanelContainer
var onboarding_arrow: Label
var onboarding_card: PanelContainer
var onboarding_avatar: TextureRect
var onboarding_title_label: Label
var onboarding_body_label: Label
var onboarding_step_label: Label
var onboarding_progress_bar: ProgressBar
var onboarding_prev_button: Button
var onboarding_next_button: Button
var onboarding_step_index := 0
var onboarding_mark_seen_on_close := true


func _ready() -> void:
	randomize()
	_load_or_seed_data()
	selected_zone_id = garden_data.get("selected_zone", "active")
	_init_debug_layout()
	_build_ui()
	_build_audio()
	call_deferred("_render_all")
	call_deferred("_maybe_show_first_onboarding")


func _build_audio() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = MUTED_VOLUME_DB
	add_child(music_player)

	_update_zone_audio(true)


func _load_audio_stream(path: String) -> AudioStream:
	var resource_path := path
	if not resource_path.begins_with("res://") and not resource_path.begins_with("user://"):
		resource_path = "res://" + resource_path.trim_prefix("/")
	var stream := ResourceLoader.load(resource_path) as AudioStream
	if stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	return stream


func _update_zone_audio(instant := false) -> void:
	var music_path := DORMANT_BGM_STREAM if selected_zone_id == "dormant" else MAIN_BGM_STREAM
	var music_volume := DORMANT_BGM_VOLUME_DB if selected_zone_id == "dormant" else BGM_VOLUME_DB
	_set_music_stream(music_path, music_volume, instant)


func _set_music_stream(path: String, target_volume: float, instant := false) -> void:
	if music_player == null:
		return
	if music_tween != null:
		music_tween.kill()
	if current_music_stream == path:
		if instant:
			music_player.volume_db = target_volume
		else:
			music_tween = create_tween()
			music_tween.tween_property(music_player, "volume_db", target_volume, 0.55)
		return
	if instant:
		_start_music_stream(path, target_volume)
		return
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", MUTED_VOLUME_DB, 0.35)
	music_tween.tween_callback(Callable(self, "_start_music_stream").bind(path, target_volume))
	music_tween.tween_property(music_player, "volume_db", target_volume, 0.85)


func _start_music_stream(path: String, target_volume: float) -> void:
	var stream := _load_audio_stream(path)
	if stream == null:
		current_music_stream = ""
		return
	music_player.stream = stream
	music_player.volume_db = target_volume
	music_player.play()
	current_music_stream = path


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_inside_tree():
		_apply_root_safe_area_offsets()
		call_deferred("_render_map")
		if onboarding_overlay != null and onboarding_overlay.visible:
			call_deferred("_update_onboarding_layout")


func _process(delta: float) -> void:
	animation_time += delta
	if debug_mode:
		return
	for button in animated_plot_buttons:
		if not is_instance_valid(button):
			continue
		var phase := float(button.get_meta("phase", 0.0))
		var amount := float(button.get_meta("amount", 0.026))
		var speed := float(button.get_meta("speed", 0.34))
		var base_position: Vector2 = button.get_meta("base_position", button.position)
		var sway := sin((animation_time + phase) * TAU * speed)
		button.position = base_position + Vector2(sway * 2.0, 0.0)
		button.rotation = sway * amount
	var live_stage_textures: Array[TextureRect] = []
	for icon in animated_stage_textures:
		if not is_instance_valid(icon):
			continue
		live_stage_textures.append(icon)
		var frames: Array = icon.get_meta("stage_animation_frames", [])
		if frames.is_empty():
			continue
		var fps := float(icon.get_meta("stage_animation_fps", 5.55))
		var frame_index := int(floor(animation_time * fps)) % frames.size()
		if int(icon.get_meta("stage_animation_frame", -1)) == frame_index:
			continue
		icon.texture = _load_texture(str(frames[frame_index]))
		icon.set_meta("stage_animation_frame", frame_index)
	animated_stage_textures = live_stage_textures
	for node in animated_ambient_nodes:
		if not is_instance_valid(node):
			continue
		var phase := float(node.get_meta("phase", 0.0))
		var base_position: Vector2 = node.get_meta("base_position", node.position)
		var speed := float(node.get_meta("speed", 1.0))
		var travel := float(node.get_meta("travel", 1.0))
		var scale_amount := float(node.get_meta("scale_amount", 0.0))
		var motion := str(node.get_meta("motion", "drift"))
		var loop_t := fposmod(animation_time * speed + phase, 1.0)
		var drift := sin((animation_time * speed + phase) * TAU * 0.22)
		var flutter := cos((animation_time * speed + phase) * TAU * 0.48)
		if motion == "fall":
			var fall_wave := sin((animation_time * 0.45 + phase) * TAU)
			node.position = base_position + Vector2(fall_wave * 7.0 * travel, loop_t * 34.0 * travel)
			node.rotation = fall_wave * 0.26
			var color := node.modulate
			color.a = 0.25 + (1.0 - loop_t) * 0.65
			node.modulate = color
		elif motion == "flyby":
			node.position = base_position + Vector2((loop_t - 0.5) * 84.0 * travel, sin(loop_t * TAU) * 10.0 * travel)
			node.rotation = sin(loop_t * TAU) * 0.35
		elif motion == "sparkle":
			var pulse := 0.5 + sin((animation_time * speed + phase) * TAU) * 0.5
			var fx_scale := 0.78 + pulse * scale_amount
			node.position = base_position + Vector2(drift * 3.0 * travel, flutter * 2.0 * travel)
			node.scale = Vector2(fx_scale, fx_scale)
			var color := node.modulate
			color.a = 0.35 + pulse * 0.55
			node.modulate = color
		else:
			node.position = base_position + Vector2(drift * 8.0 * travel, flutter * 4.0 * travel)
			node.rotation = drift * 0.18
			if scale_amount > 0.0:
				var fx_scale := 1.0 + flutter * scale_amount
				node.scale = Vector2(fx_scale, fx_scale)


func _input(event: InputEvent) -> void:
	if onboarding_overlay != null and onboarding_overlay.visible:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_finish_onboarding()
			get_viewport().set_input_as_handled()
		return

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
	if not garden_data.has("onboarding_seen"):
		garden_data["onboarding_seen"] = false
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
				if not plot.has("quick_record_labels"):
					plot["quick_record_labels"] = _default_quick_record_labels(str(plot.get("kind", "")))
				if not plot.has("record_history"):
					plot["record_history"] = []
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
	_sync_save_metadata()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(garden_data, "\t"))


func _sync_save_metadata() -> void:
	garden_data["selected_zone"] = selected_zone_id
	garden_data["layout_version"] = LAYOUT_VERSION


func _write_json(path: String, data: Dictionary) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true


func _make_export_payload() -> Dictionary:
	_sync_save_metadata()
	var export_data := garden_data.duplicate(true)
	return {
		"app": "academic-garden",
		"schema_version": SAVE_SCHEMA_VERSION,
		"exported_at": Time.get_datetime_string_from_system(true),
		"layout_version": LAYOUT_VERSION,
		"data": export_data,
		"checksum": _save_checksum(export_data)
	}


func _save_checksum(data: Dictionary) -> String:
	return JSON.stringify(data).sha256_text()


func _default_backup_dir() -> String:
	var documents := OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	if not documents.is_empty():
		return documents
	return ProjectSettings.globalize_path("user://")


func _show_backup_panel() -> void:
	if backup_panel == null:
		return
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_set_backup_status("自动存档位置：%s" % SAVE_PATH)
	backup_panel.visible = true


func _hide_backup_panel() -> void:
	if backup_panel != null:
		backup_panel.visible = false


func _set_backup_status(text: String) -> void:
	if backup_status_label != null:
		backup_status_label.text = text


func _open_export_dialog() -> void:
	if export_dialog == null:
		return
	export_dialog.current_dir = _default_backup_dir()
	export_dialog.current_file = EXPORT_FILE_NAME
	export_dialog.popup_centered_ratio(0.92)


func _open_import_dialog() -> void:
	if import_dialog == null:
		return
	import_dialog.current_dir = _default_backup_dir()
	import_dialog.current_file = ""
	import_dialog.popup_centered_ratio(0.92)


func _export_save_to_path(path: String) -> void:
	var payload := _make_export_payload()
	if _write_json(path, payload):
		_set_backup_status("已导出：%s" % path)
	else:
		_set_backup_status("导出失败：无法写入 %s" % path)


func _import_save_from_path(path: String) -> void:
	var payload := _read_json(path)
	var import_result := _extract_import_data(payload)
	if not bool(import_result.get("ok", false)):
		_set_backup_status("导入失败：%s" % import_result.get("message", "文件格式不正确"))
		return

	if not _write_json(IMPORT_BACKUP_PATH, _make_export_payload()):
		_set_backup_status("导入失败：无法备份当前存档")
		return

	garden_data = (import_result["data"] as Dictionary).duplicate(true)
	selected_zone_id = str(garden_data.get("selected_zone", "active"))
	if _zone_index_by_id(selected_zone_id) < 0:
		selected_zone_id = "active"
	selected_plot_id = ""
	selected_decor_id = ""
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_upgrade_saved_maps()
	_save_data()
	_update_zone_audio()
	_render_all()
	_set_backup_status("已导入：%s。原存档备份在 %s" % [path, IMPORT_BACKUP_PATH])


func _extract_import_data(payload: Dictionary) -> Dictionary:
	if payload.is_empty():
		return {"ok": false, "message": "无法读取 JSON"}

	var imported_data: Dictionary = {}
	if payload.has("data"):
		if str(payload.get("app", "")) != "academic-garden":
			return {"ok": false, "message": "不是学术花园存档"}
		if int(payload.get("schema_version", 0)) > SAVE_SCHEMA_VERSION:
			return {"ok": false, "message": "存档版本过新"}
		if typeof(payload.get("data")) != TYPE_DICTIONARY:
			return {"ok": false, "message": "缺少花园数据"}
		imported_data = payload["data"]
		if payload.has("checksum") and str(payload.get("checksum", "")) != _save_checksum(imported_data):
			return {"ok": false, "message": "校验失败，文件可能已损坏"}
	else:
		imported_data = payload

	if not _is_valid_save_data(imported_data):
		return {"ok": false, "message": "缺少必要字段"}
	return {"ok": true, "data": imported_data}


func _is_valid_save_data(data: Dictionary) -> bool:
	return data.has("zones") and typeof(data.get("zones")) == TYPE_ARRAY and data.has("decoration_catalog")


func _build_ui() -> void:
	_add_background()
	root_box = VBoxContainer.new()
	root_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_box.add_theme_constant_override("separation", 6)
	_apply_root_safe_area_offsets()
	add_child(root_box)

	_build_header()
	_build_map()
	_build_detail_panel()
	_build_decor_bar()
	_build_backup_panel()
	_build_debug_panel()
	_build_onboarding_overlay()


func _apply_root_safe_area_offsets() -> void:
	if root_box == null:
		return
	var margins := _root_safe_area_margins()
	root_box.offset_left = margins.x
	root_box.offset_top = margins.y
	root_box.offset_right = -margins.z
	root_box.offset_bottom = -margins.w


func _root_safe_area_margins() -> Vector4:
	var margins := Vector4(ROOT_MARGIN_PX, ROOT_MARGIN_PX, ROOT_MARGIN_PX, ROOT_MARGIN_PX)
	var window_size := Vector2(DisplayServer.window_get_size())
	var viewport_size := get_viewport_rect().size
	if window_size.x <= 0.0 or window_size.y <= 0.0 or viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return margins

	var safe_area := DisplayServer.get_display_safe_area()
	if safe_area.size.x <= 0 or safe_area.size.y <= 0:
		return margins

	var window_position := Vector2(DisplayServer.window_get_position())
	var safe_position := Vector2(safe_area.position) - window_position
	var safe_size := Vector2(safe_area.size)
	var safe_area_scale := Vector2(viewport_size.x / window_size.x, viewport_size.y / window_size.y)
	var left := clampf(safe_position.x, 0.0, window_size.x)
	var top := clampf(safe_position.y, 0.0, window_size.y)
	var right := clampf(window_size.x - (safe_position.x + safe_size.x), 0.0, window_size.x)
	var bottom := clampf(window_size.y - (safe_position.y + safe_size.y), 0.0, window_size.y)

	margins.x = maxf(ROOT_MARGIN_PX, ROOT_MARGIN_PX + left * safe_area_scale.x)
	margins.y = maxf(ROOT_MARGIN_PX, ROOT_MARGIN_PX + top * safe_area_scale.y)
	margins.z = maxf(ROOT_MARGIN_PX, ROOT_MARGIN_PX + right * safe_area_scale.x)
	margins.w = maxf(ROOT_MARGIN_PX, ROOT_MARGIN_PX + bottom * safe_area_scale.y)
	return margins


func _add_background() -> void:
	var texture := _load_texture(APP_BACKGROUND_SPRITE)
	if texture != null:
		var textured_background := TextureRect.new()
		textured_background.texture = texture
		textured_background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		textured_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		textured_background.stretch_mode = TextureRect.STRETCH_SCALE
		textured_background.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(textured_background)
		return

	var background := ColorRect.new()
	background.color = Color("#8a552b")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)


func _build_header() -> void:
	var header_panel := PanelContainer.new()
	header_panel.custom_minimum_size = Vector2(0, 68)
	header_panel.add_theme_stylebox_override("panel", _hud_panel_style())
	root_box.add_child(header_panel)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	header_panel.add_child(header)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 0)
	header.add_child(title_box)

	title_logo = TextureRect.new()
	title_logo.texture = _load_texture(TITLE_LOGO_SPRITE)
	title_logo.custom_minimum_size = Vector2(126, 46)
	title_logo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_logo.size_flags_vertical = Control.SIZE_EXPAND_FILL
	title_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	title_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	title_box.add_child(title_logo)

	title_label = Label.new()
	title_label.visible = false
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.add_theme_color_override("font_color", Color("#203820"))
	title_box.add_child(title_label)

	meta_label = Label.new()
	meta_label.visible = false
	meta_label.add_theme_font_size_override("font_size", 11)
	meta_label.add_theme_color_override("font_color", Color("#4f6545"))
	meta_label.clip_text = true
	title_box.add_child(meta_label)

	var coins_panel := PanelContainer.new()
	coins_panel.custom_minimum_size = Vector2(82, 44)
	coins_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	coins_panel.add_theme_stylebox_override("panel", _hud_pill_style())
	header.add_child(coins_panel)

	var coins_box := HBoxContainer.new()
	coins_box.alignment = BoxContainer.ALIGNMENT_CENTER
	coins_box.add_theme_constant_override("separation", 4)
	coins_panel.add_child(coins_box)

	coins_icon = TextureRect.new()
	coins_icon.texture = _load_texture(COIN_ICON_SPRITE)
	coins_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	coins_icon.custom_minimum_size = Vector2(24, 24)
	coins_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coins_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	coins_box.add_child(coins_icon)

	coins_label = Label.new()
	coins_label.custom_minimum_size = Vector2(42, 0)
	coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	coins_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	coins_label.add_theme_font_size_override("font_size", 13)
	coins_label.add_theme_color_override("font_color", Color("#fff0ba"))
	coins_label.add_theme_color_override("font_shadow_color", Color("#3e2615"))
	coins_label.add_theme_constant_override("shadow_offset_x", 1)
	coins_label.add_theme_constant_override("shadow_offset_y", 1)
	coins_box.add_child(coins_label)

	guide_button = Button.new()
	guide_button.text = "新手引导"
	guide_button.custom_minimum_size = Vector2(74, 44)
	guide_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	guide_button.add_theme_font_size_override("font_size", 12)
	guide_button.add_theme_stylebox_override("normal", _button_style(Color("#b9cf74")))
	guide_button.add_theme_stylebox_override("hover", _button_style(Color("#cfe388")))
	guide_button.add_theme_stylebox_override("pressed", _button_style(Color("#91aa54")))
	guide_button.pressed.connect(_show_onboarding.bind(true))
	header.add_child(guide_button)

	backup_button = Button.new()
	backup_button.text = "备份"
	backup_button.custom_minimum_size = Vector2(48, 44)
	backup_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	backup_button.add_theme_font_size_override("font_size", 12)
	backup_button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	backup_button.add_theme_stylebox_override("hover", _button_style(Color("#e8c87d")))
	backup_button.add_theme_stylebox_override("pressed", _button_style(Color("#b98245")))
	backup_button.pressed.connect(_show_backup_panel)
	header.add_child(backup_button)


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
	hint_label.custom_minimum_size = Vector2(0, 26)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_font_size_override("font_size", 12)
	hint_label.add_theme_color_override("font_color", Color("#fff7d6"))
	hint_label.add_theme_color_override("font_shadow_color", Color("#2d2a1f"))
	hint_label.add_theme_constant_override("shadow_offset_x", 1)
	hint_label.add_theme_constant_override("shadow_offset_y", 1)

	var hint_panel := PanelContainer.new()
	hint_panel.custom_minimum_size = Vector2(0, 30)
	hint_panel.add_theme_stylebox_override("panel", _hint_panel_style())
	hint_panel.add_child(hint_label)
	root_box.add_child(hint_panel)


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
	detail_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
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
	history_button = _detail_action_button("查看记录", _on_history_pressed)
	teach_button = _detail_action_button("快速浇水", _on_teach_pressed)
	advance_button = _detail_action_button("推进阶段", _on_advance_pressed)
	sleep_button = _detail_action_button("移入睡眠园", _on_sleep_pressed)
	wake_button = _detail_action_button("唤醒", _on_wake_pressed)
	remove_button = _detail_action_button("移除", _on_remove_pressed)

	_build_record_panel()
	_build_record_history_panel()
	_build_plant_panel()
	_detail_panel_action_visibility()


func _build_decor_bar() -> void:
	var decor_panel := PanelContainer.new()
	decor_panel.custom_minimum_size = Vector2(0, 88)
	decor_panel.add_theme_stylebox_override("panel", _tray_panel_style())
	root_box.add_child(decor_panel)

	var scroller := ScrollContainer.new()
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	decor_panel.add_child(scroller)

	decor_bar = HBoxContainer.new()
	decor_bar.add_theme_constant_override("separation", 7)
	scroller.add_child(decor_bar)


func _build_backup_panel() -> void:
	backup_panel = PanelContainer.new()
	backup_panel.anchor_left = 0.0
	backup_panel.anchor_top = 1.0
	backup_panel.anchor_right = 1.0
	backup_panel.anchor_bottom = 1.0
	backup_panel.offset_left = 24
	backup_panel.offset_top = -356
	backup_panel.offset_right = -24
	backup_panel.offset_bottom = -96
	backup_panel.visible = false
	backup_panel.z_as_relative = false
	backup_panel.z_index = 1700
	backup_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(backup_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	backup_panel.add_child(box)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 8)
	box.add_child(header_row)

	var title := Label.new()
	title.text = "存档备份"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("#263522"))
	header_row.add_child(title)

	var close_button := _corner_close_button(_hide_backup_panel)
	header_row.add_child(close_button)

	var hint := Label.new()
	hint.text = "导出当前花园数据，或导入备份恢复。导入前会先保存当前本地存档。"
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color("#5a4a35"))
	box.add_child(hint)

	var help := Label.new()
	help.text = _backup_help_text()
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_font_size_override("font_size", 11)
	help.add_theme_color_override("font_color", Color("#334231"))
	box.add_child(help)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	box.add_child(actions)

	var export_button := _backup_action_button("导出", _open_export_dialog)
	actions.add_child(export_button)

	var import_button := _backup_action_button("导入", _open_import_dialog)
	actions.add_child(import_button)

	backup_status_label = Label.new()
	backup_status_label.text = "自动存档位置：%s" % SAVE_PATH
	backup_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	backup_status_label.add_theme_font_size_override("font_size", 10)
	backup_status_label.add_theme_color_override("font_color", Color("#6b4a1f"))
	box.add_child(backup_status_label)

	export_dialog = FileDialog.new()
	export_dialog.access = FileDialog.ACCESS_FILESYSTEM
	export_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	export_dialog.filters = PackedStringArray(["*.json ; JSON"])
	export_dialog.current_file = EXPORT_FILE_NAME
	export_dialog.title = "导出学术花园存档"
	export_dialog.file_selected.connect(_export_save_to_path)
	add_child(export_dialog)

	import_dialog = FileDialog.new()
	import_dialog.access = FileDialog.ACCESS_FILESYSTEM
	import_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	import_dialog.filters = PackedStringArray(["*.json ; JSON"])
	import_dialog.title = "导入学术花园存档"
	import_dialog.file_selected.connect(_import_save_from_path)
	add_child(import_dialog)


func _backup_action_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 34)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_stylebox_override("normal", _button_style(Color("#7b9b58")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#8db066")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#5f7f42")))
	button.pressed.connect(callable)
	return button


func _backup_help_text() -> String:
	return "导出：选择手机里的一个文件夹保存备份，文件通常会出现在“文件/下载/文档”或你选的网盘目录。\n导入：点导入，找到 academic-garden-save.json，确认后花园会恢复到备份状态。\n换手机：先把备份文件发到新手机，再在新手机里导入。"


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


func _build_onboarding_overlay() -> void:
	onboarding_overlay = Control.new()
	onboarding_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	onboarding_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	onboarding_overlay.visible = false
	onboarding_overlay.z_as_relative = false
	onboarding_overlay.z_index = ONBOARDING_Z_INDEX
	add_child(onboarding_overlay)

	var dim := ColorRect.new()
	dim.color = Color(0.05, 0.06, 0.04, 0.68)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	onboarding_overlay.add_child(dim)

	onboarding_highlight = PanelContainer.new()
	onboarding_highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	onboarding_highlight.add_theme_stylebox_override("panel", _onboarding_highlight_style())
	onboarding_overlay.add_child(onboarding_highlight)

	onboarding_arrow = Label.new()
	onboarding_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	onboarding_arrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	onboarding_arrow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	onboarding_arrow.add_theme_font_size_override("font_size", 28)
	onboarding_arrow.add_theme_color_override("font_color", Color("#fff0a5"))
	onboarding_arrow.add_theme_color_override("font_shadow_color", Color("#3a2415"))
	onboarding_arrow.add_theme_constant_override("shadow_offset_x", 1)
	onboarding_arrow.add_theme_constant_override("shadow_offset_y", 2)
	onboarding_overlay.add_child(onboarding_arrow)

	onboarding_card = PanelContainer.new()
	onboarding_card.mouse_filter = Control.MOUSE_FILTER_STOP
	onboarding_card.add_theme_stylebox_override("panel", _onboarding_card_style())
	onboarding_overlay.add_child(onboarding_card)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	onboarding_card.add_child(box)

	onboarding_progress_bar = ProgressBar.new()
	onboarding_progress_bar.custom_minimum_size = Vector2(0, 8)
	onboarding_progress_bar.max_value = ONBOARDING_STEPS.size()
	onboarding_progress_bar.min_value = 0
	onboarding_progress_bar.show_percentage = false
	onboarding_progress_bar.add_theme_stylebox_override("background", _onboarding_progress_style(Color("#dcc18a")))
	onboarding_progress_bar.add_theme_stylebox_override("fill", _onboarding_progress_style(Color("#7b9b58")))
	box.add_child(onboarding_progress_bar)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)

	var avatar_frame := PanelContainer.new()
	avatar_frame.custom_minimum_size = Vector2(98, 118)
	avatar_frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	avatar_frame.add_theme_stylebox_override("panel", _tray_button_style(Color("#f1d58f"), Color("#5c4128"), 2))
	row.add_child(avatar_frame)

	onboarding_avatar = TextureRect.new()
	onboarding_avatar.texture = _load_texture(DR_MEOW_SPRITE)
	onboarding_avatar.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	onboarding_avatar.custom_minimum_size = Vector2(94, 112)
	onboarding_avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	onboarding_avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	avatar_frame.add_child(onboarding_avatar)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 5)
	row.add_child(text_box)

	var mentor_label := Label.new()
	mentor_label.text = "喵博士 Dr.Meow"
	mentor_label.add_theme_font_size_override("font_size", 11)
	mentor_label.add_theme_color_override("font_color", Color("#6b4a1f"))
	text_box.add_child(mentor_label)

	onboarding_title_label = Label.new()
	onboarding_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	onboarding_title_label.add_theme_font_size_override("font_size", 16)
	onboarding_title_label.add_theme_color_override("font_color", Color("#263522"))
	text_box.add_child(onboarding_title_label)

	onboarding_body_label = Label.new()
	onboarding_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	onboarding_body_label.add_theme_font_size_override("font_size", 13)
	onboarding_body_label.add_theme_color_override("font_color", Color("#4d3a24"))
	text_box.add_child(onboarding_body_label)

	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	box.add_child(nav)

	onboarding_step_label = Label.new()
	onboarding_step_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	onboarding_step_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	onboarding_step_label.add_theme_font_size_override("font_size", 11)
	onboarding_step_label.add_theme_color_override("font_color", Color("#6b4a1f"))
	nav.add_child(onboarding_step_label)

	var skip_button := _onboarding_button("跳过", _finish_onboarding)
	nav.add_child(skip_button)

	onboarding_prev_button = _onboarding_button("上一步", _on_onboarding_prev_pressed)
	nav.add_child(onboarding_prev_button)

	onboarding_next_button = _onboarding_button("下一步", _on_onboarding_next_pressed)
	nav.add_child(onboarding_next_button)


func _onboarding_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(64, 44)
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#e8c87d")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#b98245")))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#9b927e")))
	button.pressed.connect(callable)
	return button


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


func _hud_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.40, 0.24, 0.13, 0.72)
	style.border_color = Color(0.22, 0.13, 0.08, 0.88)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 8
	style.content_margin_top = 6
	style.content_margin_right = 8
	style.content_margin_bottom = 6
	return style


func _hud_pill_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.28, 0.17, 0.09, 0.72)
	style.border_color = Color(0.76, 0.55, 0.25, 0.86)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 7
	style.corner_radius_top_right = 7
	style.corner_radius_bottom_left = 7
	style.corner_radius_bottom_right = 7
	style.content_margin_left = 6
	style.content_margin_top = 3
	style.content_margin_right = 6
	style.content_margin_bottom = 3
	return style


func _hint_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.18, 0.15, 0.10, 0.58)
	style.border_color = Color(0.96, 0.78, 0.42, 0.30)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 7
	style.corner_radius_top_right = 7
	style.corner_radius_bottom_left = 7
	style.corner_radius_bottom_right = 7
	style.content_margin_left = 8
	style.content_margin_top = 2
	style.content_margin_right = 8
	style.content_margin_bottom = 2
	return style


func _onboarding_highlight_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.91, 0.42, 0.12)
	style.border_color = Color("#fff0a5")
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	return style


func _onboarding_card_style() -> StyleBoxFlat:
	var style := _panel_style(Color("#f8e8bf"), Color("#5c4128"))
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.content_margin_left = 12
	style.content_margin_top = 12
	style.content_margin_right = 12
	style.content_margin_bottom = 12
	return style


func _onboarding_progress_style(fill_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style


func _tray_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.31, 0.19, 0.11, 0.76)
	style.border_color = Color(0.17, 0.10, 0.06, 0.92)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 7
	style.content_margin_top = 7
	style.content_margin_right = 7
	style.content_margin_bottom = 7
	return style


func _contact_shadow_style(alpha := 0.34) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.09, 0.05, alpha)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style


func _tray_button_style(fill_color: Color, border_color: Color, border_width := 2) -> StyleBoxFlat:
	var style := _button_style(fill_color)
	style.border_color = border_color
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
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
	record_panel.offset_top = -404
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

	record_quick_buttons = []
	for index in range(QUICK_RECORD_SLOT_COUNT):
		record_quick_buttons.append(_record_button("", _record_quick_action_pressed.bind(index), quick_grid, CARE_ICON_SPRITES["record"]))

	var edit_grid := GridContainer.new()
	edit_grid.columns = 3
	edit_grid.add_theme_constant_override("h_separation", 5)
	box.add_child(edit_grid)

	record_quick_label_inputs = []
	for index in range(QUICK_RECORD_SLOT_COUNT):
		var input := LineEdit.new()
		input.placeholder_text = "按钮%d" % (index + 1)
		input.custom_minimum_size = Vector2(0, 28)
		input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		input.add_theme_font_size_override("font_size", 10)
		record_quick_label_inputs.append(input)
		edit_grid.add_child(input)

	record_quick_save_button = Button.new()
	record_quick_save_button.text = "保存快捷文字"
	record_quick_save_button.custom_minimum_size = Vector2(0, 30)
	record_quick_save_button.add_theme_font_size_override("font_size", 11)
	record_quick_save_button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	record_quick_save_button.pressed.connect(_save_quick_record_labels_from_inputs)
	box.add_child(record_quick_save_button)

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


func _build_record_history_panel() -> void:
	record_history_panel = PanelContainer.new()
	record_history_panel.anchor_left = 0.0
	record_history_panel.anchor_top = 1.0
	record_history_panel.anchor_right = 1.0
	record_history_panel.anchor_bottom = 1.0
	record_history_panel.offset_left = 24
	record_history_panel.offset_top = -332
	record_history_panel.offset_right = -24
	record_history_panel.offset_bottom = -98
	record_history_panel.visible = false
	record_history_panel.z_as_relative = false
	record_history_panel.z_index = 1610
	record_history_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(record_history_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	record_history_panel.add_child(box)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	var title := Label.new()
	title.text = "项目记录"
	title.add_theme_font_size_override("font_size", 14)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)

	var close_button := Button.new()
	close_button.text = "x"
	close_button.custom_minimum_size = Vector2(32, 28)
	close_button.add_theme_font_size_override("font_size", 12)
	close_button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	close_button.pressed.connect(_hide_record_history_panel)
	row.add_child(close_button)

	record_history_text = Label.new()
	record_history_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	record_history_text.add_theme_font_size_override("font_size", 11)
	record_history_text.add_theme_color_override("font_color", Color("#334231"))
	record_history_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(record_history_text)


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
	button.custom_minimum_size = Vector2(0, 36)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_stylebox_override("normal", _button_style(Color("#7b9b58")))
	if not str(icon_path).is_empty():
		var content := HBoxContainer.new()
		content.mouse_filter = Control.MOUSE_FILTER_IGNORE
		content.set_anchors_preset(Control.PRESET_FULL_RECT)
		content.offset_left = 8
		content.offset_right = -8
		content.alignment = BoxContainer.ALIGNMENT_CENTER
		content.add_theme_constant_override("separation", 4)
		button.add_child(content)

		var icon := TextureRect.new()
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.texture = _load_texture(str(icon_path))
		icon.custom_minimum_size = Vector2(18, 18)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		content.add_child(icon)

		var label := Label.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.text = text
		label.add_theme_font_size_override("font_size", 11)
		label.add_theme_color_override("font_color", Color("#ffffff"))
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		content.add_child(label)
		button.set_meta("text_label", label)
	else:
		button.text = text
	button.pressed.connect(callable)
	parent.add_child(button)
	return button


func _set_record_button_text(button: Button, text: String) -> void:
	if button.has_meta("text_label"):
		var label := button.get_meta("text_label") as Label
		if label != null:
			label.text = text
			return
	button.text = text


func _detail_panel_action_visibility(show_record := true, show_advance := true, show_wake := false, show_remove := false) -> void:
	if log_button != null:
		log_button.visible = show_record
	if history_button != null:
		history_button.visible = show_record
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


func _maybe_show_first_onboarding() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if bool(garden_data.get("onboarding_seen", false)):
		return
	_show_onboarding(true)


func _show_onboarding(mark_seen_on_close := true) -> void:
	if onboarding_overlay == null:
		return
	onboarding_mark_seen_on_close = mark_seen_on_close
	onboarding_step_index = 0
	onboarding_overlay.visible = true
	_sync_onboarding_step()


func _finish_onboarding() -> void:
	if onboarding_overlay != null:
		onboarding_overlay.visible = false
	_hide_record_panel()
	_hide_record_history_panel()
	if onboarding_mark_seen_on_close:
		garden_data["onboarding_seen"] = true
		_save_data()


func _on_onboarding_prev_pressed() -> void:
	onboarding_step_index = maxi(onboarding_step_index - 1, 0)
	_sync_onboarding_step()


func _on_onboarding_next_pressed() -> void:
	if onboarding_step_index >= ONBOARDING_STEPS.size() - 1:
		_finish_onboarding()
		return
	onboarding_step_index += 1
	_sync_onboarding_step()


func _sync_onboarding_step() -> void:
	if onboarding_overlay == null or not onboarding_overlay.visible:
		return
	var step: Dictionary = ONBOARDING_STEPS[onboarding_step_index]
	_prepare_onboarding_step(str(step.get("target", "")))
	onboarding_title_label.text = str(step.get("title", ""))
	onboarding_body_label.text = str(step.get("body", ""))
	onboarding_step_label.text = "%d / %d" % [onboarding_step_index + 1, ONBOARDING_STEPS.size()]
	if onboarding_progress_bar != null:
		onboarding_progress_bar.value = onboarding_step_index + 1
	onboarding_prev_button.disabled = onboarding_step_index <= 0
	onboarding_next_button.text = "完成" if onboarding_step_index >= ONBOARDING_STEPS.size() - 1 else "下一步"
	await get_tree().process_frame
	_update_onboarding_layout()


func _prepare_onboarding_step(target: String) -> void:
	if target in ["detail", "record"]:
		selected_decor_id = ""
		_hide_backup_panel()
		_hide_plant_panel()
		_ensure_onboarding_plot_selected()
		_render_detail()
		if target == "record":
			_show_record_panel()
		else:
			_hide_record_panel()
		return

	if target in ["guide_button", "map", "hotspot", "plot", "decor"]:
		_hide_backup_panel()
		_hide_record_panel()
		_hide_record_history_panel()
		_hide_plant_panel()
		if target != "plot":
			selected_plot_id = ""
			_render_detail()


func _ensure_onboarding_plot_selected() -> void:
	var plot := _first_onboarding_plot()
	if plot.is_empty():
		return
	selected_plot_id = str(plot.get("id", ""))


func _first_onboarding_plot() -> Dictionary:
	for plot in _current_zone().get("plots", []):
		if str(plot.get("kind", "")) != "empty":
			return plot
	for plot in _current_zone().get("plots", []):
		return plot
	return {}


func _update_onboarding_layout() -> void:
	if onboarding_overlay == null or not onboarding_overlay.visible:
		return

	var step: Dictionary = ONBOARDING_STEPS[onboarding_step_index]
	var target_rect := _onboarding_clamped_rect(_onboarding_target_rect(str(step.get("target", ""))), 10.0)
	onboarding_highlight.position = target_rect.position
	onboarding_highlight.size = target_rect.size

	var screen_size := get_viewport_rect().size
	var card_width := minf(screen_size.x - 32.0, 360.0)
	var card_height := 260.0 if screen_size.y >= 700.0 else 238.0
	onboarding_card.custom_minimum_size = Vector2(card_width, card_height)
	onboarding_card.size = Vector2(card_width, card_height)

	var card_x := clampf(target_rect.position.x + target_rect.size.x * 0.5 - card_width * 0.5, 16.0, maxf(16.0, screen_size.x - card_width - 16.0))
	var below_y := target_rect.position.y + target_rect.size.y + 16.0
	var above_y := target_rect.position.y - card_height - 16.0
	var card_y := below_y
	var card_is_above := false
	if below_y + card_height > screen_size.y - 12.0:
		card_y = maxf(12.0, above_y)
		card_is_above = true
	onboarding_card.position = Vector2(card_x, card_y)

	onboarding_arrow.text = "▼" if card_is_above else "▲"
	onboarding_arrow.size = Vector2(42, 32)
	onboarding_arrow.position = Vector2(
		clampf(target_rect.position.x + target_rect.size.x * 0.5 - 21.0, 8.0, maxf(8.0, screen_size.x - 50.0)),
		card_y + card_height - 4.0 if card_is_above else card_y - 28.0
	)


func _onboarding_target_rect(target: String) -> Rect2:
	if target == "guide_button":
		return _control_global_rect(guide_button)
	if target == "map":
		return _control_global_rect(map_canvas)
	if target == "hotspot":
		return _onboarding_hotspot_rect()
	if target == "plot":
		return _onboarding_plot_rect()
	if target == "detail":
		return _control_global_rect(detail_panel)
	if target == "record":
		return _control_global_rect(record_panel)
	if target == "decor":
		var scroller: Control = null
		if decor_bar != null:
			scroller = decor_bar.get_parent() as Control
		return _control_global_rect(scroller)
	return _center_onboarding_rect()


func _control_global_rect(control: Control) -> Rect2:
	if control == null or not is_instance_valid(control) or not control.visible:
		return _center_onboarding_rect()
	var rect := control.get_global_rect()
	if rect.size.x <= 1.0 or rect.size.y <= 1.0:
		return _center_onboarding_rect()
	return rect


func _onboarding_hotspot_rect() -> Rect2:
	if map_canvas == null:
		return _center_onboarding_rect()
	var hotspots := _hotspots_for_zone(selected_zone_id)
	if hotspots.is_empty():
		return _control_global_rect(map_canvas)
	var hotspot: Dictionary = hotspots[0]
	var button_size: Vector2 = hotspot.get("size", Vector2(110, 82))
	var map_rect := _map_rect(map_canvas.size)
	var local_pos := _map_point(map_rect, hotspot.get("pos", Vector2(0.5, 0.18))) - button_size * 0.5
	return Rect2(map_canvas.get_global_rect().position + local_pos, button_size)


func _onboarding_plot_rect() -> Rect2:
	if map_canvas == null:
		return _center_onboarding_rect()
	var plot := _first_onboarding_plot()
	if plot.is_empty():
		return _control_global_rect(map_canvas)
	var button_size := _plot_button_size(plot)
	var map_rect := _map_rect(map_canvas.size)
	var local_pos := _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5))) - Vector2(button_size.x * 0.5, button_size.y * 0.82)
	return Rect2(map_canvas.get_global_rect().position + local_pos, button_size)


func _center_onboarding_rect() -> Rect2:
	var screen_size := get_viewport_rect().size
	return Rect2(screen_size * 0.5 - Vector2(56, 42), Vector2(112, 84))


func _onboarding_clamped_rect(rect: Rect2, padding: float) -> Rect2:
	var screen_size := get_viewport_rect().size
	var target_size := Vector2(
		clampf(rect.size.x + padding * 2.0, 36.0, maxf(36.0, screen_size.x - 24.0)),
		clampf(rect.size.y + padding * 2.0, 30.0, maxf(30.0, screen_size.y - 24.0))
	)
	var target_position := rect.position - Vector2(padding, padding)
	target_position.x = clampf(target_position.x, 12.0, maxf(12.0, screen_size.x - target_size.x - 12.0))
	target_position.y = clampf(target_position.y, 12.0, maxf(12.0, screen_size.y - target_size.y - 12.0))
	return Rect2(target_position, target_size)


func _update_header() -> void:
	var zone := _current_zone()
	title_label.text = zone.get("title", "Garden")
	meta_label.text = zone.get("subtitle", "")
	coins_label.text = "金币 %d" % int(garden_data.get("coins", 0))


func _render_map() -> void:
	if overlay_layer == null or not is_instance_valid(overlay_layer):
		return

	for child in overlay_layer.get_children():
		child.queue_free()
	animated_plot_buttons.clear()
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
	_log_runtime_layout_once(map_rect)


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

		_render_hotspot_sign(button.position, button_size, hotspot.get("label", ""))
		hotspot_index += 1


func _render_hotspot_sign(button_position: Vector2, button_size: Vector2, label_text: String) -> void:
	var sign_panel := PanelContainer.new()
	sign_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sign_panel.size = Vector2(82, 24)
	sign_panel.position = button_position + Vector2((button_size.x - sign_panel.size.x) * 0.5, button_size.y - 17)
	sign_panel.add_theme_stylebox_override("panel", _tray_button_style(Color("#c6904f"), Color("#5c351b"), 2))
	sign_panel.z_index = 1200
	overlay_layer.add_child(sign_panel)

	var hotspot_label := Label.new()
	hotspot_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hotspot_label.text = label_text
	hotspot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hotspot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hotspot_label.add_theme_font_size_override("font_size", 12)
	hotspot_label.add_theme_color_override("font_color", Color("#fff0be"))
	hotspot_label.add_theme_color_override("font_shadow_color", Color("#432612"))
	hotspot_label.add_theme_constant_override("shadow_offset_x", 1)
	hotspot_label.add_theme_constant_override("shadow_offset_y", 1)
	sign_panel.add_child(hotspot_label)


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
		var plot_id := str(plot.get("id", ""))
		var button_size := _plot_button_size(plot)

		button.flat = true
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.custom_minimum_size = button_size
		button.size = button_size
		button.clip_contents = false
		button.position = _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5))) - Vector2(button_size.x * 0.5, button_size.y * 0.82)
		button.z_index = _depth_z_index(plot)
		button.clip_text = true
		button.text = ""
		button.tooltip_text = "%s\n%s" % [_display_title(plot), _status_label(str(plot.get("status", "")))]
		var sprite_filter := _zone_sprite_filter() if kind != "empty" else {}
		if kind != "empty":
			_add_contact_shadow(button, button_size, 0.46, 0.16)
		_add_button_texture(button, plot.get("sprite", ""), sprite_filter)
		var item := {"type": "plot", "zone": selected_zone_id, "id": plot_id}
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
		var button_size := _decor_button_size(placed)
		button.flat = true
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.custom_minimum_size = button_size
		button.size = button_size
		button.position = _map_point(map_rect, Vector2(placed.get("x", 0.5), placed.get("y", 0.5))) - Vector2(button_size.x * 0.5, button_size.y * 0.82)
		button.z_index = _depth_z_index(placed)
		button.text = ""
		button.tooltip_text = "收回%s" % decor.get("title", "装饰")
		_add_contact_shadow(button, button_size, 0.62, 0.30)
		_add_button_texture(button, decor.get("sprite", ""), _zone_sprite_filter())
		var item := {"type": "decoration", "zone": selected_zone_id, "index": decor_index, "id": str(placed.get("id", ""))}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_remove_decoration.bind(placed))
		overlay_layer.add_child(button)
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
		button.custom_minimum_size = Vector2(52, 52)
		button.size = Vector2(52, 52)
		button.position = _map_point(map_rect, slot) - Vector2(26, 40)
		button.z_index = 1350
		button.add_theme_stylebox_override("normal", _tray_button_style(Color(0.39, 0.71, 0.42, 0.24), Color("#fff0a5"), 2))
		button.add_theme_stylebox_override("hover", _tray_button_style(Color(0.55, 0.86, 0.49, 0.34), Color("#fff7bd"), 3))
		button.tooltip_text = "放置选中的装饰"
		if not debug_mode:
			_add_button_texture(button, FX_SPRITES["placement"])
			button.modulate = Color(1.0, 1.0, 1.0, 0.94)
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
		_hide_record_history_panel()
		return

	var detail_sprite_path := str(plot.get("portrait_sprite", plot.get("sprite", "")))
	detail_icon.texture = _load_texture(detail_sprite_path)
	_apply_stage_animation(detail_icon, detail_sprite_path)
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
	var feedback := _plant_feedback(plot)
	button.pivot_offset = Vector2(button.size.x * 0.5, button.size.y * 0.82)
	var stage := str(plot.get("stage", ""))
	var amount := float(feedback.get("amount", 0.035 if stage in ["tree", "flower", "bloom", "fruit"] else 0.018))
	button.set_meta("amount", amount)
	button.set_meta("phase", float(feedback.get("phase", 0.0)))
	button.set_meta("speed", float(feedback.get("speed", 0.34)))
	button.set_meta("base_position", button.position)
	animated_plot_buttons.append(button)


func _plant_feedback(plot: Dictionary) -> Dictionary:
	var plot_id := str(plot.get("id", ""))
	if plot_id.is_empty():
		plot_id = str(plot.get("sprite", ""))
	if plant_feedback_by_id.has(plot_id):
		return plant_feedback_by_id[plot_id]

	var stage := str(plot.get("stage", ""))
	var mature := stage in ["tree", "flower", "bloom", "fruit"]
	var effects := ["sway", "leaf", "flyby", "sparkle"] if mature else ["sway", "sparkle"]
	var effect := str(effects[randi() % effects.size()])
	var feedback := {
		"effect": effect,
		"phase": randf(),
		"amount": randf_range(0.018, 0.04) if mature else randf_range(0.012, 0.02),
		"speed": randf_range(0.24, 0.43),
		"fx_speed": randf_range(0.55, 0.95),
		"travel": randf_range(0.55, 0.95)
	}
	plant_feedback_by_id[plot_id] = feedback
	return feedback


func _plot_feedback_fx_path(plot: Dictionary, effect: String) -> String:
	if effect == "leaf":
		return FX_SPRITES["harvested"]
	if effect == "flyby":
		return FX_SPRITES["course"]
	if effect == "sparkle":
		return FX_SPRITES["lantern"] if selected_zone_id == "dormant" else FX_SPRITES["paper"]
	var kind := str(plot.get("kind", ""))
	return FX_SPRITES["paper"] if kind == "paper" else FX_SPRITES["course"]


func _plot_feedback_offsets(effect: String, button_size: Vector2) -> Array:
	if effect == "leaf":
		return [
			Vector2(-button_size.x * 0.24, -button_size.y * 0.78),
			Vector2(button_size.x * 0.04, -button_size.y * 0.86),
			Vector2(button_size.x * 0.25, -button_size.y * 0.72)
		]
	if effect == "flyby":
		return [Vector2(-button_size.x * 0.42, -button_size.y * 0.76)]
	return [
		Vector2(-button_size.x * 0.20, -button_size.y * 0.78),
		Vector2(button_size.x * 0.24, -button_size.y * 0.66)
	]


func _render_plot_ambient(map_rect: Rect2, plot: Dictionary, button_size: Vector2) -> void:
	if str(plot.get("id", "")) != selected_plot_id:
		return
	var stage := str(plot.get("stage", ""))
	if not (stage in ["tree", "flower", "bloom", "fruit"]):
		return
	var feedback := _plant_feedback(plot)
	var effect := str(feedback.get("effect", "sway"))
	if effect == "sway":
		return
	var origin := _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5)))
	var fx_path := _plot_feedback_fx_path(plot, effect)
	var offsets := _plot_feedback_offsets(effect, button_size)
	for index in offsets.size():
		var target_size := Vector2(20, 20) if effect == "flyby" else Vector2(18, 18)
		var mote := _make_fx_sprite(fx_path, target_size)
		mote.position = origin + offsets[index] - (mote.size * 0.5)
		mote.z_index = _depth_z_index(plot) + 1
		mote.set_meta("base_position", mote.position)
		mote.set_meta("phase", fposmod(float(feedback.get("phase", 0.0)) + float(index) * 0.31, 1.0))
		mote.set_meta("speed", float(feedback.get("fx_speed", 0.85)) + float(index) * 0.12)
		mote.set_meta("travel", float(feedback.get("travel", 0.65)))
		mote.set_meta("scale_amount", 0.42 if effect == "sparkle" else 0.08)
		mote.set_meta("motion", "fall" if effect == "leaf" else effect)
		overlay_layer.add_child(mote)
		animated_ambient_nodes.append(mote)

func _render_decor_bar() -> void:
	for child in decor_bar.get_children():
		child.queue_free()

	for decor in garden_data.get("decoration_catalog", []):
		var owned := _owned_count(decor.get("id", ""))
		var is_selected := str(decor.get("id", "")) == selected_decor_id
		var button := Button.new()
		button.custom_minimum_size = Vector2(60, 68)
		button.size = Vector2(60, 68)
		button.clip_text = true
		button.text = ""
		button.disabled = owned <= 0
		button.tooltip_text = "选择%s" % decor.get("title", "装饰")
		var fill := Color("#f2d486") if is_selected else Color("#c79858")
		var border := Color("#fff0a5") if is_selected else Color("#5c351b")
		button.add_theme_stylebox_override("normal", _tray_button_style(fill, border, 3 if is_selected else 2))
		button.add_theme_stylebox_override("hover", _tray_button_style(Color("#e6bd70"), Color("#fff4b6"), 3))
		button.add_theme_stylebox_override("pressed", _tray_button_style(Color("#b87739"), Color("#fff4b6"), 3))
		button.add_theme_stylebox_override("disabled", _tray_button_style(Color("#6e6650"), Color("#413827"), 2))
		button.modulate = Color(1, 1, 1, 1) if owned > 0 else Color(0.58, 0.56, 0.50, 0.78)
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
		count_label.offset_top = -18
		count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(count_label)
		button.pressed.connect(_select_decoration.bind(decor.get("id", "")))
		decor_bar.add_child(button)


func _update_hint() -> void:
	if debug_mode:
		hint_label.text = "DEBUG: drag items. [ / ] resize. \\ export. F2 exit."
	elif not selected_decor_id.is_empty():
		var decor := _decor_by_id(selected_decor_id)
		hint_label.text = "把%s放到发光位置" % decor.get("title", "装饰")
	else:
		hint_label.text = "轻点植物、装饰或小屋"


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
		"runtime": _runtime_layout_snapshot(_map_rect(map_canvas.size) if map_canvas != null else Rect2()),
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
	if typeof(value) == TYPE_VECTOR2I:
		return {"x": value.x, "y": value.y}
	if typeof(value) == TYPE_VECTOR4:
		return {"x": value.x, "y": value.y, "z": value.z, "w": value.w}
	if typeof(value) == TYPE_RECT2:
		return {
			"position": _debug_export_to_jsonable(value.position),
			"size": _debug_export_to_jsonable(value.size)
		}
	if typeof(value) == TYPE_RECT2I:
		return {
			"position": _debug_export_to_jsonable(value.position),
			"size": _debug_export_to_jsonable(value.size)
		}
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
	_update_zone_audio()
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_save_data()
	_render_all()


func _select_plot(plot_id: String) -> void:
	selected_plot_id = plot_id
	selected_decor_id = ""
	_hide_record_panel()
	_hide_record_history_panel()
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
	_hide_record_history_panel()
	_hide_plant_panel()
	call_deferred("_render_map")


func _on_log_pressed() -> void:
	_show_record_panel()


func _on_history_pressed() -> void:
	_show_record_history_panel()


func _on_teach_pressed() -> void:
	_record_care("water", "Teaching logged")


func _show_record_panel() -> void:
	if record_panel == null:
		return
	_hide_plant_panel()
	_hide_record_history_panel()
	record_panel.visible = not selected_plot_id.is_empty()
	_sync_record_quick_controls()
	if record_note_input != null:
		record_note_input.text = ""


func _hide_record_panel() -> void:
	if record_panel != null:
		record_panel.visible = false


func _show_record_history_panel() -> void:
	if record_history_panel == null:
		return
	_hide_plant_panel()
	_hide_record_panel()
	var plot := _selected_plot()
	record_history_panel.visible = not plot.is_empty()
	if record_history_text != null:
		record_history_text.text = _record_history_summary(plot)


func _hide_record_history_panel() -> void:
	if record_history_panel != null:
		record_history_panel.visible = false


func _show_plant_panel() -> void:
	if plant_panel == null:
		return
	if detail_panel != null:
		detail_panel.visible = false
	_hide_record_panel()
	_hide_record_history_panel()
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
		plot["quick_record_labels"] = _default_quick_record_labels(kind)
		plot["record_history"] = []
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


func _default_quick_record_labels(kind: String) -> Array:
	if QUICK_RECORD_DEFAULTS.has(kind):
		return QUICK_RECORD_DEFAULTS[kind].duplicate()
	return QUICK_RECORD_DEFAULTS["default"].duplicate()


func _quick_record_labels(plot: Dictionary) -> Array:
	var defaults := _default_quick_record_labels(str(plot.get("kind", "")))
	var labels: Array = plot.get("quick_record_labels", [])
	var normalized: Array = []
	for index in range(QUICK_RECORD_SLOT_COUNT):
		var label := ""
		if index < labels.size():
			label = str(labels[index]).strip_edges()
		if label.is_empty():
			label = str(defaults[index])
		normalized.append(label)
	return normalized


func _quick_labels_from_inputs(plot: Dictionary) -> Array:
	var labels := _quick_record_labels(plot)
	for index in range(mini(record_quick_label_inputs.size(), QUICK_RECORD_SLOT_COUNT)):
		var input := record_quick_label_inputs[index] as LineEdit
		var label := input.text.strip_edges()
		if not label.is_empty():
			labels[index] = label
	return labels


func _sync_record_quick_controls() -> void:
	var plot := _selected_plot()
	if plot.is_empty():
		return
	var labels := _quick_record_labels(plot)
	for index in range(QUICK_RECORD_SLOT_COUNT):
		if index < record_quick_buttons.size():
			var button := record_quick_buttons[index] as Button
			_set_record_button_text(button, str(labels[index]))
		if index < record_quick_label_inputs.size():
			var input := record_quick_label_inputs[index] as LineEdit
			input.text = str(labels[index])


func _save_quick_record_labels_from_inputs() -> void:
	var plot := _selected_plot()
	if plot.is_empty():
		return
	var labels := _quick_labels_from_inputs(plot)
	_set_selected_plot_quick_labels(labels)
	_sync_record_quick_controls()
	_save_data()


func _set_selected_plot_quick_labels(labels: Array) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return
	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id and str(plots[index].get("kind", "")) != "empty":
			plots[index]["quick_record_labels"] = labels.duplicate()
			garden_data["zones"][zone_index]["plots"] = plots
			return


func _append_plot_record_history(plot: Dictionary, text: String, record_type: String) -> void:
	var history: Array = plot.get("record_history", [])
	history.append({
		"text": text,
		"type": record_type,
		"created_at": Time.get_datetime_string_from_system(true)
	})
	if history.size() > 50:
		history = history.slice(history.size() - 50)
	plot["record_history"] = history


func _record_history_summary(plot: Dictionary) -> String:
	if plot.is_empty():
		return ""
	var history: Array = plot.get("record_history", [])
	if history.is_empty():
		var log_count := int(plot.get("logs", 0))
		if log_count > 0:
			return "已有%d条记录；旧数据没有保存明细。" % log_count
		return "暂无记录。"

	var lines: Array = []
	var shown := mini(history.size(), 8)
	for offset in range(shown):
		var item: Variant = history[history.size() - 1 - offset]
		if typeof(item) == TYPE_DICTIONARY:
			var record := item as Dictionary
			var stamp := str(record.get("created_at", ""))
			if stamp.length() > 16:
				stamp = stamp.substr(0, 16)
			var text := str(record.get("text", ""))
			if stamp.is_empty():
				lines.append(text)
			else:
				lines.append("%s  %s" % [stamp, text])
		else:
			lines.append(str(item))
	var summary := ""
	for line in lines:
		if not summary.is_empty():
			summary += "\n"
		summary += str(line)
	return summary


func _record_quick_water_pressed() -> void:
	_record_quick_action_pressed(0)


func _record_quick_sun_pressed() -> void:
	_record_quick_action_pressed(1)


func _record_quick_fertilizer_pressed() -> void:
	_record_quick_action_pressed(2)


func _record_quick_action_pressed(slot_index: int) -> void:
	var plot := _selected_plot()
	if plot.is_empty():
		return
	var labels := _quick_labels_from_inputs(plot)
	_set_selected_plot_quick_labels(labels)
	_record_action(str(labels[slot_index]), slot_index)


func _record_note_pressed() -> void:
	if record_note_input == null or record_note_input.text.strip_edges().is_empty():
		_record_quick_action_pressed(0)
		return
	_record_note(record_note_input.text.strip_edges())


func _record_action(action_text: String, slot_index: int) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty():
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = action_text
			plots[index]["growth"] = int(plots[index].get("growth", 0)) + 4
			if str(plots[index].get("kind", "")) == "course" and slot_index == 1:
				plots[index]["sessions"] = int(plots[index].get("sessions", 0)) + 1
			_append_plot_record_history(plots[index], action_text, "quick")
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_hide_record_panel()
	_hide_record_history_panel()
	_render_detail()
	call_deferred("_render_map")


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
	_hide_record_history_panel()
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
			plots[index]["status"] = "Recorded"
			plots[index]["note"] = note_text
			_append_plot_record_history(plots[index], note_text, "note")
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_hide_record_panel()
	_hide_record_history_panel()
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
	_hide_record_history_panel()
	_hide_plant_panel()
	_save_data()
	_render_all()


func _select_decoration(decor_id: String) -> void:
	selected_plot_id = ""
	selected_decor_id = decor_id
	_hide_record_panel()
	_hide_record_history_panel()
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
	history_button.text = "查看记录"
	teach_button.text = "快捷%s" % CARE_LABELS.get("water", "水")
	advance_button.text = _next_action_label(plot)
	sleep_button.text = "移入睡眠园"
	wake_button.text = "唤醒"
	remove_button.text = "移除"
	log_button.disabled = is_empty or not is_active
	history_button.disabled = is_empty
	teach_button.disabled = is_empty or kind != "course" or not is_active
	advance_button.disabled = is_empty or not is_active or _next_stage(plot).is_empty()
	sleep_button.disabled = is_empty or not is_active
	wake_button.disabled = is_empty or not is_dormant
	remove_button.disabled = is_empty
	_detail_panel_action_visibility(is_active and not is_empty, is_active and not is_empty, is_dormant and not is_empty, not is_empty and not is_active)
	if is_empty:
		log_button.text = "稍后种植"
		history_button.text = "暂无记录"
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
	return base * float(plot.get("size_scale", 1.0)) * _foreground_depth_scale(float(plot.get("y", 0.5)))


func _decor_button_size(placed: Dictionary) -> Vector2:
	var decor_scale := float(placed.get("size_scale", 1.0))
	return DEFAULT_DECOR_SIZE * decor_scale * _foreground_depth_scale(float(placed.get("y", 0.5)))


func _foreground_depth_scale(y_ratio: float) -> float:
	var t := clampf((y_ratio - 0.42) / 0.36, 0.0, 1.0)
	return lerpf(0.94, 1.08, t)


func _add_contact_shadow(button: Button, object_size: Vector2, width_ratio := 0.58, alpha := 0.34) -> void:
	var shadow := PanelContainer.new()
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.size = Vector2(object_size.x * width_ratio, maxf(6.0, object_size.y * 0.075))
	shadow.position = Vector2((object_size.x - shadow.size.x) * 0.5, object_size.y * 0.78)
	shadow.add_theme_stylebox_override("panel", _contact_shadow_style(alpha))
	button.add_child(shadow)


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


func _runtime_layout_snapshot(map_rect := Rect2()) -> Dictionary:
	var safe_area := DisplayServer.get_display_safe_area()
	return {
		"layout_version": LAYOUT_VERSION,
		"platform_android": OS.has_feature("android"),
		"viewport_size": get_viewport_rect().size,
		"window_size": DisplayServer.window_get_size(),
		"safe_area": safe_area,
		"root_offsets": Vector4(root_box.offset_left, root_box.offset_top, root_box.offset_right, root_box.offset_bottom) if root_box != null else Vector4.ZERO,
		"map_canvas_size": map_canvas.size if map_canvas != null else Vector2.ZERO,
		"map_rect": map_rect,
		"save_path": ProjectSettings.globalize_path(SAVE_PATH)
	}


func _log_runtime_layout_once(map_rect: Rect2) -> void:
	if runtime_layout_logged:
		return
	runtime_layout_logged = true
	print("AcademicGardenRuntimeLayout=", JSON.stringify(_debug_export_to_jsonable(_runtime_layout_snapshot(map_rect))))


func _load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	var resource_path := path
	if not resource_path.begins_with("res://") and not resource_path.begins_with("user://"):
		resource_path = "res://" + resource_path.trim_prefix("/")
	if texture_cache.has(resource_path):
		return texture_cache[resource_path]

	if resource_path == DR_MEOW_SPRITE:
		var direct_texture := _load_image_texture(resource_path)
		if direct_texture != null:
			return direct_texture

	var loaded := ResourceLoader.load(resource_path)
	if loaded is Texture2D:
		texture_cache[resource_path] = loaded
		return loaded

	return _load_image_texture(resource_path)


func _load_image_texture(resource_path: String) -> Texture2D:
	var image := Image.new()
	var error := image.load(resource_path)
	if error != OK:
		return null

	var texture := ImageTexture.create_from_image(image)
	texture_cache[resource_path] = texture
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
	_apply_stage_animation(icon, path)


func _apply_stage_animation(icon: TextureRect, path: String) -> void:
	var frames := _stage_animation_frames(path)
	if frames.is_empty():
		if icon.has_meta("stage_animation_frames"):
			icon.remove_meta("stage_animation_frames")
		if icon.has_meta("stage_animation_frame"):
			icon.remove_meta("stage_animation_frame")
		return
	icon.set_meta("stage_animation_frames", frames)
	icon.set_meta("stage_animation_fps", 5.55)
	icon.set_meta("stage_animation_frame", -1)
	icon.texture = _load_texture(str(frames[0]))
	if not animated_stage_textures.has(icon):
		animated_stage_textures.append(icon)


func _stage_animation_frames(path: String) -> Array:
	var base := _plant_sprite_base(path)
	if not base.begins_with("paper-"):
		return []
	var stage := ""
	for candidate in ["tree", "flower", "fruit"]:
		if base.ends_with("-%s" % candidate):
			stage = candidate
			break
	if stage.is_empty():
		return []
	var anim_dir := "res://assets/sprites/stage-animations/paper-trees/%s" % base
	var frames: Array = []
	for index in range(6):
		var frame_path := "%s/frame-%02d.png" % [anim_dir, index]
		if not FileAccess.file_exists(frame_path):
			return []
		frames.append(frame_path)
	return frames


func _make_fx_sprite(path: String, target_size: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = _load_texture(path)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.clip_contents = true
	icon.custom_minimum_size = target_size
	icon.size = target_size
	icon.pivot_offset = target_size * 0.5
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_SCALE
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
