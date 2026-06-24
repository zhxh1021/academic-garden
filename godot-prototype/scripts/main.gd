extends Control

const EconomyRules := preload("res://scripts/economy_rules.gd")
const LayoutRules := preload("res://scripts/layout_rules.gd")
const PlantRules := preload("res://scripts/plant_rules.gd")
const SaveRules := preload("res://scripts/save_rules.gd")
const SAVE_PATH := "user://garden_state.json"
const IMPORT_BACKUP_PATH := "user://garden_state.before-import.json"
const SAVE_SCHEMA_VERSION := 1
const EXPORT_FILE_NAME := "academic-garden-save.json"
const SEED_PATH := "res://data/garden_seed.json"
const DEBUG_EXPORT_PATH := "user://layout_debug_export.json"
const DEBUG_EXPORT_PROJECT_PATH := "res://layout_debug_export.json"
const LAYOUT_VERSION := 30
const HARVESTED_PAGE_SIZE := LayoutRules.HARVESTED_PAGE_SIZE
const MAP_DISPLAY_ASPECT := LayoutRules.MAP_DISPLAY_ASPECT
const ROOT_MARGIN_PX := LayoutRules.ROOT_MARGIN_PX
const APP_BACKGROUND_SPRITE := "res://assets/sprites/ui/app-wood-bg-v1.png"
const TITLE_LOGO_SPRITE := "res://assets/sprites/ui/academic-garden-logo-gpt-v1.png"
const COIN_ICON_SPRITE := "res://assets/sprites/coin-v1.png"
const DR_MEOW_SPRITE := "res://assets/sprites/ui/dr-meow-guide-gpt-v1.png"
const SEED_SHOP_ICON_SPRITE := "res://assets/sprites/ui/seed-shop-gpt-v1.png"
const SEED_LOCKED_ICON_SPRITE := "res://assets/sprites/ui/seed-locked-gpt-v1.png"
const UI_FONT_SIZE_CAPTION := 11
const UI_FONT_SIZE_BODY := 14
const UI_FONT_SIZE_BUTTON := 13
const UI_FONT_SIZE_TITLE := 17
const UI_TONE_PRIMARY := "primary"
const UI_TONE_NEUTRAL := "neutral"
const UI_TONE_WOOD := "wood"
const UI_TONE_DANGER := "danger"
const UI_TONE_SLEEP := "sleep"
const UI_TONE_DISABLED := "disabled"
const MAIN_BGM_STREAM := "res://assets/audio/garden_bgm_main_loop.wav"
const DORMANT_BGM_STREAM := "res://assets/audio/garden_bgm_dormant_loop.wav"
const BGM_VOLUME_DB := -6.0
const DORMANT_BGM_VOLUME_DB := -8.0
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
const DEFAULT_PLOT_SIZES := LayoutRules.DEFAULT_PLOT_SIZES
const STAGE_PLOT_SIZES := LayoutRules.STAGE_PLOT_SIZES
const DEFAULT_DECOR_SIZE := LayoutRules.DEFAULT_DECOR_SIZE
const PLOT_GROUND_ANCHOR_Y := LayoutRules.PLOT_GROUND_ANCHOR_Y
const PLANT_MAP_SCALE := LayoutRules.PLANT_MAP_SCALE
const FX_SPRITES := {
	"placement": "res://assets/sprites/sprout/fx/fx-placement-ring.png"
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
	"harvested-1": Vector2(0.295, 0.471),
	"harvested-2": Vector2(0.500, 0.471),
	"harvested-3": Vector2(0.720, 0.471),
	"harvested-4": Vector2(0.295, 0.592),
	"harvested-5": Vector2(0.500, 0.592),
	"harvested-6": Vector2(0.720, 0.592),
	"harvested-7": Vector2(0.295, 0.728),
	"harvested-8": Vector2(0.500, 0.728),
	"harvested-9": Vector2(0.720, 0.728),
	"dormant-1": Vector2(0.295, 0.471),
	"dormant-2": Vector2(0.500, 0.471),
	"dormant-3": Vector2(0.720, 0.471),
	"dormant-4": Vector2(0.295, 0.592),
	"dormant-5": Vector2(0.500, 0.592),
	"dormant-6": Vector2(0.720, 0.592),
	"dormant-7": Vector2(0.295, 0.728),
	"dormant-8": Vector2(0.500, 0.728),
	"dormant-9": Vector2(0.720, 0.728)
}
const PLOT_SIZE_SCALES := {
	"active-1": 1.0,
	"active-2": 1.0,
	"active-3": 1.0,
	"active-4": 1.0,
	"active-5": 1.0,
	"active-6": 1.0,
	"active-7": 1.0,
	"active-8": 1.0,
	"active-9": 1.0,
	"harvested-1": 1.0,
	"harvested-2": 1.0,
	"harvested-3": 1.0,
	"harvested-4": 1.0,
	"harvested-5": 1.0,
	"harvested-6": 1.0,
	"harvested-7": 1.0,
	"harvested-8": 1.0,
	"harvested-9": 0.96,
	"dormant-1": 1.0,
	"dormant-2": 1.0,
	"dormant-3": 1.0,
	"dormant-4": 1.0,
	"dormant-5": 1.0,
	"dormant-6": 1.0,
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
const DECOR_SIZE_SCALES := LayoutRules.DECOR_SIZE_SCALES
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
	"paper": PlantRules.STAGE_FLOW["paper"],
	"course": PlantRules.STAGE_FLOW["course"]
}
const PLANTABLE_ZONE_IDS := ["active"]
const INITIAL_UNLOCKED_VARIETY_COUNT := 2
const FLOWER_VARIETY_UNLOCK_PRICE := EconomyRules.FLOWER_VARIETY_UNLOCK_PRICE
const TREE_VARIETY_UNLOCK_BASE_PRICE := EconomyRules.TREE_VARIETY_UNLOCK_BASE_PRICE
const PLANT_VARIETIES := {
	"paper": [
		{"label": "银杏", "base": "paper-ginkgo"},
		{"label": "樱桃", "base": "paper-cherry"},
		{"label": "枫树", "base": "paper-maple"},
		{"label": "柳树", "base": "paper-willow"},
		{"label": "松树", "base": "paper-pine"},
		{"label": "香樟", "base": "paper-camphor"}
	],
	"course": [
		{"label": "雏菊", "base": "course-daisy"},
		{"label": "玫瑰", "base": "course-rose"},
		{"label": "莲花", "base": "course-lotus"},
		{"label": "薰衣草", "base": "course-lavender"},
		{"label": "绣球", "base": "course-hydrangea"},
		{"label": "向日葵", "base": "course-sunflower"}
	]
}
const COURSE_STAGE_KEY_MIGRATIONS := {
	"sowing": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["sowing"],
	"growing": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["growing"],
	"fruit": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["fruit"],
	"seed_saved": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["seed_saved"],
	"fruit-bloom": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["fruit-bloom"],
	"seed_saved-blossom": PlantRules.COURSE_STAGE_KEY_MIGRATIONS["seed_saved-blossom"]
}
const STAGE_LABELS := {
	"seed": "种子",
	"sapling": "幼苗",
	"tree": "成树",
	"flower": "开花",
	"fruit": "成果",
	"seedling": "幼苗",
	"bud": "含苞",
	"bloom": "盛开",
	"blossom": "绽放",
	"empty": "空地"
}
const NEXT_ACTION_LABELS := {
	"paper:seed": "确定选题",
	"paper:sapling": "写出第一版草稿",
	"paper:tree": "投稿",
	"paper:flower": "成功发表",
	"course:seed": "备课",
	"course:seedling": "开始上课",
	"course:bud": "结课",
	"course:bloom": "提交成绩"
}
const CARE_LABELS := {"sun": "阳光", "water": "水", "fertilizer": "肥料"}
const CARE_TYPES := ["sun", "water", "fertilizer"]
const RANDOM_DOUBLE_CARE_CHANCE := 0.10
const DAILY_GROWTH_CAP := EconomyRules.DAILY_GROWTH_CAP
const DAILY_COIN_GROWTH_UNIT := EconomyRules.DAILY_COIN_GROWTH_UNIT
const DAILY_COIN_BASE := EconomyRules.DAILY_COIN_BASE
const DAILY_COIN_RANDOM_MIN := EconomyRules.DAILY_COIN_RANDOM_MIN
const DAILY_COIN_RANDOM_MAX := EconomyRules.DAILY_COIN_RANDOM_MAX
const DAILY_COIN_PLANT_CAP := EconomyRules.DAILY_COIN_PLANT_CAP
const STAGE_COIN_MULTIPLIERS := EconomyRules.STAGE_COIN_MULTIPLIERS
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
		"body": "我是 Dr.Meow, 负责带你逛第一圈。学术花园把论文、课程和想法种成植物：轻点、记录、推进，它们就会从种子长成成果。"
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

var garden_data: Dictionary = {}
var selected_zone_id := "active"
var selected_plot_id := ""
var selected_decor_id := ""
var decor_mode := "inventory"
var harvested_page_index := 0
var moving_plot_id := ""
var selected_decoration_index := -1
var moving_decoration_index := -1
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
var detail_growth_value: Label
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
var plant_variety_label: Label
var plant_variety_grid: GridContainer
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
var move_button: Button
var record_water_button: Button
var record_sun_button: Button
var record_fertilizer_button: Button
var record_note_button: Button
var sleep_button: Button
var wake_button: Button
var remove_button: Button
var remove_confirm_overlay: Control
var remove_confirm_card: PanelContainer
var remove_confirm_title_label: Label
var remove_confirm_body_label: Label
var remove_confirm_cancel_button: Button
var remove_confirm_ok_button: Button
var pending_remove_zone_id := ""
var pending_remove_plot_id := ""
var decor_action_panel: PanelContainer
var decor_action_title: Label
var decor_move_button: Button
var decor_reclaim_button: Button
var decor_cancel_button: Button
var decor_inventory_button: Button
var decor_shop_button: Button
var seed_shop_button: Button
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
		if remove_confirm_overlay != null and remove_confirm_overlay.visible:
			call_deferred("_update_remove_confirm_layout")


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
		var drift := sin((animation_time * speed + phase) * TAU * 0.22)
		var flutter := cos((animation_time * speed + phase) * TAU * 0.48)
		node.position = base_position + Vector2(drift * 8.0 * travel, flutter * 4.0 * travel)
		node.rotation = drift * 0.18
		if scale_amount > 0.0:
			var fx_scale := 1.0 + flutter * scale_amount
			node.scale = Vector2(fx_scale, fx_scale)


func _input(event: InputEvent) -> void:
	if remove_confirm_overlay != null and remove_confirm_overlay.visible:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_hide_remove_confirmation()
			get_viewport().set_input_as_handled()
		return

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
			_sync_decoration_catalog()
			_upgrade_saved_maps()
			_sync_unlocked_varieties(true)
			_settle_daily_economy()
			_save_data()
			return

	garden_data = _read_json(SEED_PATH)
	if not garden_data.has("zones"):
		garden_data = {"zones": [], "decoration_catalog": [], "owned_decorations": {}}
	_sync_decoration_catalog()
	_upgrade_saved_maps()
	_sync_unlocked_varieties()
	_settle_daily_economy()
	_save_data()


func _sync_decoration_catalog() -> void:
	var seed := _read_json(SEED_PATH)
	var seed_catalog: Array = seed.get("decoration_catalog", [])
	if not seed_catalog.is_empty():
		garden_data["decoration_catalog"] = seed_catalog
	var owned: Dictionary = garden_data.get("owned_decorations", {})
	for decor in garden_data.get("decoration_catalog", []):
		var decor_id := str(decor.get("id", ""))
		if not decor_id.is_empty() and not owned.has(decor_id):
			owned[decor_id] = 0
	garden_data["owned_decorations"] = owned


func _sync_unlocked_varieties(include_existing_plants := false) -> void:
	var unlocked: Dictionary = garden_data.get("unlocked_varieties", {})
	for kind in PLANT_VARIETIES.keys():
		var bases: Array = _unlocked_variety_bases(kind)
		var varieties: Array = PLANT_VARIETIES.get(kind, [])
		for index in range(mini(INITIAL_UNLOCKED_VARIETY_COUNT, varieties.size())):
			var base := str((varieties[index] as Dictionary).get("base", ""))
			if not base.is_empty() and not bases.has(base):
				bases.append(base)
		unlocked[kind] = bases
	if not include_existing_plants:
		garden_data["unlocked_varieties"] = unlocked
		return
	for zone in garden_data.get("zones", []):
		for plot in (zone as Dictionary).get("plots", []):
			var plot_dict := plot as Dictionary
			var kind := str(plot_dict.get("kind", ""))
			if not PLANT_VARIETIES.has(kind):
				continue
			var base := _plant_variety_base(plot_dict)
			if base.is_empty():
				continue
			var bases: Array = unlocked.get(kind, [])
			if not bases.has(base):
				bases.append(base)
				unlocked[kind] = bases
	garden_data["unlocked_varieties"] = unlocked


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
			_normalize_plot_stage_key(plot)
			if should_migrate_plot_positions and PLOT_ANCHORS.has(plot_id):
				var plot_anchor: Vector2 = PLOT_ANCHORS[plot_id]
				plot["x"] = plot_anchor.x
				plot["y"] = plot_anchor.y
				plot["size_scale"] = PLOT_SIZE_SCALES.get(plot_id, 1.0)
			if str(plot.get("kind", "")) == "empty":
				plot["sprite"] = ""
				plot.erase("portrait_sprite")
			else:
				plot["sprite"] = _web_stage_sprite_path(plot)
				plot["portrait_sprite"] = plot["sprite"]
				if should_migrate_plot_positions:
					plot["size_scale"] = PLOT_SIZE_SCALES.get(plot_id, 1.0)
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
			if should_migrate_decor_positions:
				placed["size_scale"] = _decor_default_scale(decor_id)
				decorations[decor_index] = placed
		zone["decorations"] = decorations
		garden_data["zones"][index] = zone
	garden_data["layout_version"] = LAYOUT_VERSION


func _normalize_plot_stage_key(plot: Dictionary) -> void:
	var kind := str(plot.get("kind", ""))
	var stage := str(plot.get("stage", ""))
	var normalized_stage := PlantRules.normalize_stage_key(kind, stage)
	if normalized_stage != stage:
		plot["stage"] = normalized_stage


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


func _today_key() -> String:
	return Time.get_date_string_from_system(false)


func _settle_daily_economy() -> void:
	var today := _today_key()
	if str(garden_data.get("last_settlement_date", "")) == today:
		return
	if not garden_data.has("last_settlement_date"):
		garden_data["last_settlement_date"] = today
		garden_data["last_settlement_summary"] = {"date": today, "coins": 0, "growth": 0, "plants": 0}
		return

	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var total_coins := 0
	var total_growth := 0
	var settled_plants := 0
	for zone_index in garden_data.get("zones", []).size():
		var zone: Dictionary = garden_data["zones"][zone_index]
		var zone_id := str(zone.get("id", ""))
		if zone_id == "dormant":
			continue
		var plots: Array = zone.get("plots", [])
		for plot_index in plots.size():
			var plot: Dictionary = plots[plot_index]
			if str(plot.get("kind", "")) == "empty":
				continue
			var growth_added := 0
			if zone_id == "active":
				growth_added = _daily_growth_from_care(plot.get("care_today", {}))
				if growth_added > 0:
					plot["growth"] = int(plot.get("growth", 0)) + growth_added
					total_growth += growth_added
				plot["care_today"] = {"sun": 0, "water": 0, "fertilizer": 0}
			var plant_coins := _daily_coins_for_plot(plot, rng)
			if plant_coins <= 0:
				plots[plot_index] = plot
				continue
			total_coins += plant_coins
			settled_plants += 1
			plots[plot_index] = plot
		zone["plots"] = plots
		garden_data["zones"][zone_index] = zone
	if total_coins > 0:
		garden_data["coins"] = int(garden_data.get("coins", 0)) + total_coins
	garden_data["last_settlement_date"] = today
	garden_data["last_settlement_summary"] = {"date": today, "coins": total_coins, "growth": total_growth, "plants": settled_plants}


func _daily_growth_from_care(care: Dictionary) -> int:
	return EconomyRules.daily_growth_from_care(care)


func _daily_coins_for_plot(plot: Dictionary, rng: RandomNumberGenerator) -> int:
	return _daily_coins_for_plot_with_factor(
		plot,
		rng.randf_range(EconomyRules.daily_coin_random_min(), EconomyRules.daily_coin_random_max())
	)


func _estimated_daily_coins_for_plot(plot: Dictionary) -> int:
	return _daily_coins_for_plot_with_factor(plot, 1.0)


func _daily_coins_for_plot_with_factor(plot: Dictionary, random_factor: float) -> int:
	return EconomyRules.daily_coins_for_plot_with_factor(plot, random_factor)


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
	return SaveRules.make_export_payload(garden_data, SAVE_SCHEMA_VERSION, LAYOUT_VERSION, Time.get_datetime_string_from_system(true))


func _save_checksum(data: Dictionary) -> String:
	return SaveRules.save_checksum(data)


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
	return SaveRules.extract_import_data(payload, SAVE_SCHEMA_VERSION)


func _is_valid_save_data(data: Dictionary) -> bool:
	return SaveRules.is_valid_save_data(data)


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
	header_panel.custom_minimum_size = Vector2(0, 58)
	header_panel.add_theme_stylebox_override("panel", _hud_panel_style())
	root_box.add_child(header_panel)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 5)
	header_panel.add_child(header)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 0)
	header.add_child(title_box)

	title_logo = TextureRect.new()
	title_logo.texture = _load_texture(TITLE_LOGO_SPRITE)
	title_logo.custom_minimum_size = Vector2(112, 40)
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
	coins_panel.custom_minimum_size = Vector2(78, 38)
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
	coins_icon.custom_minimum_size = Vector2(22, 22)
	coins_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coins_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	coins_box.add_child(coins_icon)

	coins_label = Label.new()
	coins_label.custom_minimum_size = Vector2(40, 0)
	coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	coins_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	coins_label.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	coins_label.add_theme_color_override("font_color", Color("#fff0ba"))
	coins_label.add_theme_color_override("font_shadow_color", Color("#3e2615"))
	coins_label.add_theme_constant_override("shadow_offset_x", 1)
	coins_label.add_theme_constant_override("shadow_offset_y", 1)
	coins_box.add_child(coins_label)

	guide_button = Button.new()
	guide_button.text = "引导"
	guide_button.tooltip_text = "新手引导"
	guide_button.custom_minimum_size = Vector2(58, 38)
	guide_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	guide_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(guide_button, UI_TONE_PRIMARY)
	guide_button.pressed.connect(_show_onboarding.bind(true))
	header.add_child(guide_button)

	backup_button = Button.new()
	backup_button.text = "备份"
	backup_button.tooltip_text = "存档备份"
	backup_button.custom_minimum_size = Vector2(58, 38)
	backup_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	backup_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(backup_button, UI_TONE_WOOD)
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
	detail_panel.offset_top = -360
	detail_panel.offset_right = -18
	detail_panel.offset_bottom = -104
	detail_panel.visible = false
	detail_panel.z_as_relative = false
	detail_panel.z_index = 1500
	detail_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(detail_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
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
	detail_icon.custom_minimum_size = Vector2(0, 68)
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
	detail_title.add_theme_font_size_override("font_size", UI_FONT_SIZE_TITLE)
	detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(detail_title)

	detail_meta = Label.new()
	detail_meta.add_theme_font_size_override("font_size", UI_FONT_SIZE_CAPTION)
	detail_meta.add_theme_color_override("font_color", Color("#5a6c52"))
	detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(detail_meta)

	detail_growth_value = Label.new()
	detail_growth_value.custom_minimum_size = Vector2(0, 20)
	detail_growth_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_growth_value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_growth_value.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	detail_growth_value.add_theme_color_override("font_color", Color("#3f5d36"))
	detail_growth_value.add_theme_color_override("font_shadow_color", Color("#fff3cf"))
	detail_growth_value.add_theme_constant_override("shadow_offset_x", 1)
	detail_growth_value.add_theme_constant_override("shadow_offset_y", 1)
	box.add_child(detail_growth_value)

	detail_care_grid = GridContainer.new()
	detail_care_grid.columns = 3
	detail_care_grid.add_theme_constant_override("h_separation", 5)
	detail_care_grid.visible = true
	box.add_child(detail_care_grid)

	detail_water_value = _detail_care_cell(CARE_ICON_SPRITES["water"], "水", Color("#d7f0f4"))
	detail_sun_value = _detail_care_cell(CARE_ICON_SPRITES["sun"], "阳光", Color("#fff2b8"))
	detail_fertilizer_value = _detail_care_cell(CARE_ICON_SPRITES["fertilizer"], "肥料", Color("#e6d0a4"))

	detail_note = Label.new()
	detail_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_note.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
	detail_note.add_theme_color_override("font_color", Color("#334231"))
	detail_note.visible = false
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
	sleep_button = _detail_action_button("暂时休眠", _on_sleep_pressed)
	wake_button = _detail_action_button("唤醒", _on_wake_pressed)
	remove_button = _detail_action_button("移除", _on_remove_pressed)

	_build_record_panel()
	_build_record_history_panel()
	_build_plant_panel()
	_build_decor_action_panel()
	_build_remove_confirm_dialog()
	_detail_panel_action_visibility()


func _build_remove_confirm_dialog() -> void:
	remove_confirm_overlay = Control.new()
	remove_confirm_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	remove_confirm_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	remove_confirm_overlay.visible = false
	remove_confirm_overlay.z_as_relative = false
	remove_confirm_overlay.z_index = ONBOARDING_Z_INDEX + 20
	add_child(remove_confirm_overlay)

	var dim := ColorRect.new()
	dim.color = Color(0.05, 0.06, 0.04, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	remove_confirm_overlay.add_child(dim)

	remove_confirm_card = PanelContainer.new()
	remove_confirm_card.mouse_filter = Control.MOUSE_FILTER_STOP
	remove_confirm_card.add_theme_stylebox_override("panel", _remove_confirm_card_style())
	remove_confirm_overlay.add_child(remove_confirm_card)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	remove_confirm_card.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	box.add_child(header)

	remove_confirm_title_label = Label.new()
	remove_confirm_title_label.text = "确认移除"
	remove_confirm_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	remove_confirm_title_label.add_theme_font_size_override("font_size", 16)
	remove_confirm_title_label.add_theme_color_override("font_color", Color("#263522"))
	header.add_child(remove_confirm_title_label)

	var close_button := _corner_close_button(_hide_remove_confirmation)
	header.add_child(close_button)

	var body_row := HBoxContainer.new()
	body_row.add_theme_constant_override("separation", 10)
	box.add_child(body_row)

	var avatar_frame := PanelContainer.new()
	avatar_frame.custom_minimum_size = Vector2(74, 86)
	avatar_frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	avatar_frame.add_theme_stylebox_override("panel", _tray_button_style(Color("#f1d58f"), Color("#5c4128"), 2))
	body_row.add_child(avatar_frame)

	var avatar := TextureRect.new()
	avatar.texture = _load_texture(DR_MEOW_SPRITE)
	avatar.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	avatar.custom_minimum_size = Vector2(70, 82)
	avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	avatar_frame.add_child(avatar)

	remove_confirm_body_label = Label.new()
	remove_confirm_body_label.custom_minimum_size = Vector2(188, 0)
	remove_confirm_body_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	remove_confirm_body_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	remove_confirm_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	remove_confirm_body_label.add_theme_font_size_override("font_size", 13)
	remove_confirm_body_label.add_theme_color_override("font_color", Color("#4d3a24"))
	body_row.add_child(remove_confirm_body_label)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	box.add_child(actions)

	remove_confirm_cancel_button = _remove_confirm_button("取消", Color("#d9b46b"), _hide_remove_confirmation)
	actions.add_child(remove_confirm_cancel_button)

	remove_confirm_ok_button = _remove_confirm_button("确认移除", Color("#b86b54"), _confirm_remove_selected_plot)
	actions.add_child(remove_confirm_ok_button)

	_update_remove_confirm_layout()


func _remove_confirm_button(text: String, fill_color: Color, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _button_style(fill_color))
	button.add_theme_stylebox_override("hover", _button_style(fill_color.lightened(0.10)))
	button.add_theme_stylebox_override("pressed", _button_style(fill_color.darkened(0.14)))
	button.pressed.connect(callable)
	return button


func _update_remove_confirm_layout() -> void:
	if remove_confirm_card == null:
		return
	var viewport_size := get_viewport_rect().size
	var card_width := minf(viewport_size.x - 40.0, 438.0)
	var card_height := minf(238.0, viewport_size.y - 48.0)
	var card_y := clampf(
		viewport_size.y - card_height - 108.0,
		24.0,
		maxf(24.0, viewport_size.y - card_height - 24.0)
	)
	remove_confirm_card.size = Vector2(card_width, card_height)
	remove_confirm_card.position = Vector2(
		(viewport_size.x - card_width) * 0.5,
		card_y
	)


func _hide_remove_confirmation() -> void:
	if remove_confirm_overlay != null:
		remove_confirm_overlay.visible = false
	pending_remove_zone_id = ""
	pending_remove_plot_id = ""


func _build_decor_bar() -> void:
	var decor_panel := PanelContainer.new()
	decor_panel.custom_minimum_size = Vector2(0, 104)
	decor_panel.add_theme_stylebox_override("panel", _tray_panel_style())
	root_box.add_child(decor_panel)

	var tray_box := VBoxContainer.new()
	tray_box.add_theme_constant_override("separation", 5)
	decor_panel.add_child(tray_box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	tray_box.add_child(header)

	decor_inventory_button = _decor_mode_button("仓库", "inventory")
	decor_inventory_button.tooltip_text = "仓库"
	header.add_child(decor_inventory_button)

	decor_shop_button = _decor_mode_button("商店", "shop")
	decor_shop_button.tooltip_text = "商店"
	header.add_child(decor_shop_button)
	decor_shop_button.text = "装饰"
	decor_shop_button.tooltip_text = "装饰商店"

	seed_shop_button = _decor_mode_button("种子", "seed_shop")
	seed_shop_button.tooltip_text = "种子商店"
	header.add_child(seed_shop_button)

	move_button = Button.new()
	move_button.text = "移动"
	move_button.custom_minimum_size = Vector2(56, 26)
	move_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	move_button.pressed.connect(_on_move_plot_pressed)
	header.add_child(move_button)

	var scroller := ScrollContainer.new()
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	tray_box.add_child(scroller)

	decor_bar = HBoxContainer.new()
	decor_bar.add_theme_constant_override("separation", 6)
	scroller.add_child(decor_bar)


func _decor_mode_button(text: String, mode: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(62, 26)
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	button.pressed.connect(_set_decor_mode.bind(mode))
	return button


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
	hint.add_theme_font_size_override("font_size", UI_FONT_SIZE_CAPTION)
	hint.add_theme_color_override("font_color", Color("#5a4a35"))
	box.add_child(hint)

	var help := Label.new()
	help.text = _backup_help_text()
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
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
	button.custom_minimum_size = Vector2(64, 40)
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(button, UI_TONE_WOOD)
	button.pressed.connect(callable)
	return button


func _detail_action_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 32)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(button, UI_TONE_PRIMARY)
	button.pressed.connect(callable)
	detail_actions.add_child(button)
	return button


func _pager_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(50, 34)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_stylebox_override("normal", _button_style(Color("#d9b46b")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#e8c87d")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#b98245")))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#8a8774")))
	button.pressed.connect(callable)
	return button


func _apply_button_tone(button: Button, tone: String) -> void:
	if button == null:
		return
	var fill := _button_tone_fill(tone)
	button.add_theme_stylebox_override("normal", _button_style(fill))
	button.add_theme_stylebox_override("hover", _button_style(fill.lightened(0.10)))
	button.add_theme_stylebox_override("pressed", _button_style(fill.darkened(0.14)))
	button.add_theme_stylebox_override("disabled", _button_style(_button_tone_fill(UI_TONE_DISABLED)))


func _button_tone_fill(tone: String) -> Color:
	match tone:
		UI_TONE_PRIMARY:
			return Color("#7b9b58")
		UI_TONE_NEUTRAL:
			return Color("#d9b46b")
		UI_TONE_WOOD:
			return Color("#c6904f")
		UI_TONE_DANGER:
			return Color("#b86b54")
		UI_TONE_SLEEP:
			return Color("#7f8d73")
		UI_TONE_DISABLED:
			return Color("#8a8774")
	return Color("#d9b46b")


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


func _remove_confirm_card_style() -> StyleBoxFlat:
	var style := _panel_style(Color("#f8e8bf"), Color("#5c4128"))
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.content_margin_left = 14
	style.content_margin_top = 12
	style.content_margin_right = 14
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
	title.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)

	var close_button := Button.new()
	close_button.text = "x"
	close_button.custom_minimum_size = Vector2(32, 28)
	close_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(close_button, UI_TONE_WOOD)
	close_button.pressed.connect(_hide_record_panel)
	row.add_child(close_button)

	var quick_grid := GridContainer.new()
	quick_grid.columns = 3
	quick_grid.add_theme_constant_override("h_separation", 5)
	box.add_child(quick_grid)

	record_quick_buttons = []
	for index in range(QUICK_RECORD_SLOT_COUNT):
		var care_type := _care_type_for_record_slot(index)
		record_quick_buttons.append(_record_button("", _record_quick_action_pressed.bind(index), quick_grid, CARE_ICON_SPRITES.get(care_type, CARE_ICON_SPRITES["record"])))

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
		input.add_theme_font_size_override("font_size", UI_FONT_SIZE_CAPTION)
		record_quick_label_inputs.append(input)
		edit_grid.add_child(input)

	record_quick_save_button = Button.new()
	record_quick_save_button.text = "保存快捷文字"
	record_quick_save_button.custom_minimum_size = Vector2(0, 30)
	record_quick_save_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(record_quick_save_button, UI_TONE_WOOD)
	record_quick_save_button.pressed.connect(_save_quick_record_labels_from_inputs)
	box.add_child(record_quick_save_button)

	record_note_input = LineEdit.new()
	record_note_input.placeholder_text = "输入一条轻量记录..."
	record_note_input.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
	box.add_child(record_note_input)

	record_note_button = Button.new()
	record_note_button.text = "保存记录"
	record_note_button.custom_minimum_size = Vector2(0, 32)
	record_note_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(record_note_button, UI_TONE_PRIMARY)
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
	title.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)

	var close_button := Button.new()
	close_button.text = "x"
	close_button.custom_minimum_size = Vector2(32, 28)
	close_button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(close_button, UI_TONE_WOOD)
	close_button.pressed.connect(_hide_record_history_panel)
	row.add_child(close_button)

	record_history_text = Label.new()
	record_history_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	record_history_text.add_theme_font_size_override("font_size", UI_FONT_SIZE_BODY)
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
	plant_panel.offset_top = -386
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

	var seed_shop_icon := TextureRect.new()
	seed_shop_icon.texture = _load_texture(SEED_SHOP_ICON_SPRITE)
	seed_shop_icon.custom_minimum_size = Vector2(34, 34)
	seed_shop_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	seed_shop_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(seed_shop_icon)

	plant_title_label = Label.new()
	plant_title_label.text = "选择种子"
	plant_title_label.add_theme_font_size_override("font_size", 15)
	plant_title_label.add_theme_color_override("font_color", Color("#334231"))
	plant_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(plant_title_label)

	var close_button := _corner_close_button(_close_detail)
	row.add_child(close_button)

	var subtitle := Label.new()
	subtitle.text = "这里只负责种植已解锁品种；新种子请到底部种子商店解锁。"
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 10)
	subtitle.add_theme_color_override("font_color", Color("#5a6c52"))
	box.add_child(subtitle)

	var choices := GridContainer.new()
	choices.columns = 2
	choices.add_theme_constant_override("h_separation", 8)
	box.add_child(choices)

	plant_paper_button = _plant_kind_button("论文树", _show_plant_varieties.bind("paper"), choices, _web_stage_file_path("paper-ginkgo-seed"))
	plant_course_button = _plant_kind_button("课程花", _show_plant_varieties.bind("course"), choices, _web_stage_file_path("course-daisy-seed"))

	plant_variety_label = Label.new()
	plant_variety_label.text = "先选择一个类别"
	plant_variety_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	plant_variety_label.add_theme_font_size_override("font_size", UI_FONT_SIZE_CAPTION)
	plant_variety_label.add_theme_color_override("font_color", Color("#5a6c52"))
	box.add_child(plant_variety_label)

	plant_variety_grid = GridContainer.new()
	plant_variety_grid.columns = 3
	plant_variety_grid.add_theme_constant_override("h_separation", 6)
	plant_variety_grid.add_theme_constant_override("v_separation", 6)
	box.add_child(plant_variety_grid)


func _build_decor_action_panel() -> void:
	decor_action_panel = PanelContainer.new()
	decor_action_panel.anchor_left = 0.0
	decor_action_panel.anchor_top = 1.0
	decor_action_panel.anchor_right = 1.0
	decor_action_panel.anchor_bottom = 1.0
	decor_action_panel.offset_left = 28
	decor_action_panel.offset_top = -238
	decor_action_panel.offset_right = -28
	decor_action_panel.offset_bottom = -114
	decor_action_panel.visible = false
	decor_action_panel.z_as_relative = false
	decor_action_panel.z_index = 1500
	decor_action_panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7e7c7"), Color("#5c4128")))
	add_child(decor_action_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	decor_action_panel.add_child(box)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	decor_action_title = Label.new()
	decor_action_title.add_theme_font_size_override("font_size", 15)
	decor_action_title.add_theme_color_override("font_color", Color("#334231"))
	decor_action_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(decor_action_title)

	var close_button := _corner_close_button(_hide_decor_action_panel)
	row.add_child(close_button)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 7)
	box.add_child(actions)

	decor_move_button = _decor_action_button("移动", _on_move_decoration_pressed)
	actions.add_child(decor_move_button)

	decor_reclaim_button = _decor_action_button("收回", _on_reclaim_decoration_pressed)
	actions.add_child(decor_reclaim_button)

	decor_cancel_button = _decor_action_button("取消", _hide_decor_action_panel)
	actions.add_child(decor_cancel_button)


func _decor_action_button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 34)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _button_style(Color("#7b9b58")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#8db066")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#5f7f42")))
	button.pressed.connect(callable)
	return button


func _record_button(text: String, callable: Callable, parent: Control, icon_path := "") -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 36)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(button, UI_TONE_PRIMARY)
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
		label.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
		label.add_theme_color_override("font_color", Color("#ffffff"))
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		content.add_child(label)
		button.set_meta("text_label", label)
	else:
		button.text = text
	button.pressed.connect(callable)
	parent.add_child(button)
	return button


func _plant_kind_button(text: String, callable: Callable, parent: Control, icon_path: String) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 72)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	_apply_button_tone(button, UI_TONE_PRIMARY)
	button.text = ""
	button.pressed.connect(callable)
	parent.add_child(button)

	var content := VBoxContainer.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.offset_top = 5
	content.offset_bottom = -5
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 2)
	button.add_child(content)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.texture = _load_texture(icon_path)
	icon.custom_minimum_size = Vector2(46, 42)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content.add_child(icon)

	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	label.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(label)
	return button


func _plant_variety_button(kind: String, variety: Dictionary, parent: Control) -> Button:
	var label := str(variety.get("label", "品种"))
	var base := str(variety.get("base", ""))
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(0, 66)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", UI_FONT_SIZE_BUTTON)
	var unlocked := _is_variety_unlocked(kind, base)
	var price := _variety_unlock_price(kind)
	_apply_button_tone(button, UI_TONE_NEUTRAL if unlocked else UI_TONE_WOOD)
	button.disabled = not unlocked
	button.tooltip_text = "种植%s" % label if unlocked else "请先在底部种子商店解锁：%d金" % price
	button.modulate = Color(1, 1, 1, 1) if unlocked else Color(0.58, 0.56, 0.50, 0.82)
	if unlocked:
		button.pressed.connect(_plant_empty_plot.bind(kind, base, label))
	parent.add_child(button)

	var content := VBoxContainer.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.offset_top = 3
	content.offset_bottom = -3
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 1)
	button.add_child(content)

	var icon := TextureRect.new()
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.texture = _load_texture(_web_stage_file_path("%s-seed" % base) if unlocked else SEED_LOCKED_ICON_SPRITE)
	icon.custom_minimum_size = Vector2(44, 32)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content.add_child(icon)

	var text := Label.new()
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.text = label if unlocked else "%s\n%d金" % [label, price]
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size", 10)
	text.add_theme_color_override("font_color", Color("#fff6d6"))
	text.add_theme_color_override("font_shadow_color", Color("#4a2f19"))
	text.add_theme_constant_override("shadow_offset_x", 1)
	text.add_theme_constant_override("shadow_offset_y", 1)
	content.add_child(text)
	return button


func _set_record_button_text(button: Button, text: String) -> void:
	if button.has_meta("text_label"):
		var label := button.get_meta("text_label") as Label
		if label != null:
			label.text = text
			return
	button.text = text


func _detail_panel_action_visibility(show_record := true, show_advance := true, show_wake := false, show_remove := false, show_sleep := false) -> void:
	if log_button != null:
		log_button.visible = show_record
	if history_button != null:
		history_button.visible = show_record
	if teach_button != null:
		teach_button.visible = false
	if advance_button != null:
		advance_button.visible = show_advance
	if sleep_button != null:
		sleep_button.visible = show_sleep
	if wake_button != null:
		wake_button.visible = show_wake
	if remove_button != null:
		remove_button.visible = show_remove


func _render_all() -> void:
	_update_header()
	_render_map()
	_render_detail()
	_render_decor_bar()


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
	_update_onboarding_avatar_size(onboarding_step_index > 0)
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
	var card_height := 238.0 if onboarding_step_index > 0 else 260.0
	if screen_size.y < 700.0:
		card_height = 224.0
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


func _update_onboarding_avatar_size(compact: bool) -> void:
	if onboarding_avatar == null:
		return
	var avatar_frame := onboarding_avatar.get_parent() as PanelContainer
	if avatar_frame == null:
		return
	avatar_frame.custom_minimum_size = Vector2(54, 66) if compact else Vector2(98, 118)
	onboarding_avatar.custom_minimum_size = Vector2(50, 60) if compact else Vector2(94, 112)


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
	var local_pos := _plot_button_position(map_rect, plot, button_size)
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
	_render_harvested_pager(map_rect, zone)
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
	var plots: Array = _paged_plots_for_zone(zone)
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
		button.position = _plot_button_position(map_rect, plot, button_size)
		button.z_index = _depth_z_index(plot)
		button.clip_text = true
		button.text = ""
		button.tooltip_text = "%s\n%s" % [_display_title(plot), _status_label(str(plot.get("status", "")))]
		if kind == "empty" and _can_plant_in_zone(selected_zone_id):
			_add_empty_plot_guide(button, button_size)
		else:
			var sprite_filter := _zone_sprite_filter()
			_add_button_texture(button, plot.get("sprite", ""), sprite_filter, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		var item := {"type": "plot", "zone": selected_zone_id, "id": plot_id}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_select_plot.bind(plot.get("id", "")))
		overlay_layer.add_child(button)
		if kind != "empty" and not debug_mode:
			_animate_plot_button(button, plot)
		if debug_mode:
			_add_debug_tag(button, plot.get("id", "plot"))


func _paged_plots_for_zone(zone: Dictionary) -> Array:
	var zone_id := str(zone.get("id", ""))
	var all_plots: Array = zone.get("plots", [])
	if zone_id != "harvested":
		return all_plots.duplicate()

	harvested_page_index = _clamped_harvested_page_index(all_plots.size())
	var start_index := harvested_page_index * HARVESTED_PAGE_SIZE
	var page_plots: Array = []
	for local_index in range(HARVESTED_PAGE_SIZE):
		var source_index := start_index + local_index
		if source_index >= all_plots.size():
			break
		var display_plot: Dictionary = (all_plots[source_index] as Dictionary).duplicate(true)
		var slot_id := "harvested-%d" % (local_index + 1)
		var anchor: Vector2 = PLOT_ANCHORS.get(slot_id, Vector2(0.5, 0.64))
		display_plot["x"] = anchor.x
		display_plot["y"] = anchor.y
		display_plot["display_slot_id"] = slot_id
		page_plots.append(display_plot)
	return page_plots


func _render_harvested_pager(map_rect: Rect2, zone: Dictionary) -> void:
	if selected_zone_id != "harvested":
		return
	var plots: Array = zone.get("plots", [])
	var page_count := _harvested_page_count(plots.size())
	if page_count <= 1:
		return

	var pager := HBoxContainer.new()
	pager.size = Vector2(210, 34)
	pager.position = Vector2(map_rect.position.x + (map_rect.size.x - pager.size.x) * 0.5, map_rect.position.y + map_rect.size.y - 62)
	pager.z_index = 1450
	pager.add_theme_constant_override("separation", 6)
	overlay_layer.add_child(pager)

	var prev_button := _pager_button("<", _on_harvested_prev_page)
	prev_button.disabled = harvested_page_index <= 0
	pager.add_child(prev_button)

	var page_label := Label.new()
	page_label.custom_minimum_size = Vector2(94, 34)
	page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	page_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	page_label.text = "%d / %d" % [harvested_page_index + 1, page_count]
	page_label.add_theme_font_size_override("font_size", 13)
	page_label.add_theme_color_override("font_color", Color("#fff4c8"))
	page_label.add_theme_color_override("font_shadow_color", Color("#402914"))
	page_label.add_theme_constant_override("shadow_offset_x", 1)
	page_label.add_theme_constant_override("shadow_offset_y", 1)
	pager.add_child(page_label)

	var next_button := _pager_button(">", _on_harvested_next_page)
	next_button.disabled = harvested_page_index >= page_count - 1
	pager.add_child(next_button)


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
		button.tooltip_text = "调整%s" % decor.get("title", "装饰")
		_add_contact_shadow(button, button_size, 0.62, 0.30)
		_add_button_texture(button, decor.get("sprite", ""), _zone_sprite_filter())
		var item := {"type": "decoration", "zone": selected_zone_id, "index": decor_index, "id": str(placed.get("id", ""))}
		if debug_mode:
			_make_debug_target(button, item)
		else:
			button.pressed.connect(_select_placed_decoration.bind(decor_index))
		overlay_layer.add_child(button)
		if debug_mode:
			_add_debug_tag(button, "%s-%d" % [placed.get("id", "decor"), decor_index])
		decor_index += 1


func _render_decor_slots(map_rect: Rect2) -> void:
	if selected_decor_id.is_empty() and moving_decoration_index < 0 and not debug_mode:
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
		button.tooltip_text = "选择装饰位置"
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
			button.pressed.connect(_on_decor_slot_pressed.bind(index))
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
	var growth := int(plot.get("growth", 0))
	detail_growth_value.text = "成长值 %d / 预计日金币 %d" % [growth, _estimated_daily_coins_for_plot(plot)]
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	detail_water_value.text = str(int(care.get("water", 0)))
	detail_sun_value.text = str(int(care.get("sun", 0)))
	detail_fertilizer_value.text = str(int(care.get("fertilizer", 0)))
	detail_note.text = _display_note(plot)
	_update_detail_actions(plot)


func _play_care_feedback_for_selected_plot(care_type: String, amount: int) -> void:
	if overlay_layer == null or map_canvas == null:
		return
	var plot := _selected_plot()
	if plot.is_empty():
		return
	var map_rect := _map_rect(map_canvas.size)
	var plot_size := _plot_button_size(plot)
	var plot_position := _plot_button_position(map_rect, plot, plot_size)
	var effect_center := plot_position + Vector2(plot_size.x * 0.5, plot_size.y * 0.46)
	if care_type == "water":
		_play_water_care_effect(effect_center, plot_size)
	elif care_type == "sun":
		_play_sun_care_effect(effect_center, plot_size)
	elif care_type == "fertilizer":
		_play_fertilizer_care_effect(effect_center, plot_size)
	var start_position := plot_position + Vector2(plot_size.x * 0.5 - 32.0, -22.0)
	var badge := PanelContainer.new()
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.position = start_position
	badge.size = Vector2(64, 34)
	badge.z_index = 1720
	badge.add_theme_stylebox_override("panel", _hud_pill_style())
	overlay_layer.add_child(badge)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 3)
	badge.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _load_texture(str(CARE_ICON_SPRITES.get(care_type, CARE_ICON_SPRITES["record"])))
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var label := Label.new()
	label.text = "+%d" % amount
	label.add_theme_font_size_override("font_size", UI_FONT_SIZE_TITLE)
	label.add_theme_color_override("font_color", Color("#fff6d6"))
	label.add_theme_color_override("font_shadow_color", Color("#4a2f19"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	row.add_child(label)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(badge, "position", start_position + Vector2(0, -42), 0.72).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(badge, "modulate:a", 0.0, 0.72).set_delay(0.16)
	tween.tween_property(badge, "scale", Vector2(1.14, 1.14), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_callback(badge.queue_free)


func _play_water_care_effect(center: Vector2, plot_size: Vector2) -> void:
	for index in range(5):
		var drop := _care_draw_node(Vector2(14, 18), 1704)
		drop.position = center + Vector2(-28.0 + index * 14.0, -plot_size.y * 0.58 - randf_range(0.0, 14.0))
		drop.draw.connect(_draw_water_drop.bind(drop))
		overlay_layer.add_child(drop)
		var target := drop.position + Vector2(randf_range(-5.0, 5.0), plot_size.y * 0.56 + randf_range(8.0, 16.0))
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(drop, "position", target, 0.48 + index * 0.035).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(drop, "modulate:a", 0.0, 0.22).set_delay(0.36 + index * 0.03)
		tween.set_parallel(false)
		tween.tween_callback(drop.queue_free)
	_play_ground_ripple(center + Vector2(0, plot_size.y * 0.26), Color("#82d8ef"))


func _play_sun_care_effect(center: Vector2, plot_size: Vector2) -> void:
	var burst := _care_draw_node(Vector2(108, 108), 1702)
	burst.position = center - burst.size * 0.5 + Vector2(0, -plot_size.y * 0.15)
	burst.pivot_offset = burst.size * 0.5
	burst.draw.connect(_draw_sun_burst.bind(burst))
	overlay_layer.add_child(burst)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(burst, "scale", Vector2(1.24, 1.24), 0.46).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(burst, "rotation", 0.28, 0.56).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(burst, "modulate:a", 0.0, 0.38).set_delay(0.24)
	tween.set_parallel(false)
	tween.tween_callback(burst.queue_free)


func _play_fertilizer_care_effect(center: Vector2, plot_size: Vector2) -> void:
	for index in range(9):
		var speck := _care_draw_node(Vector2(10, 10), 1705)
		var x_offset := randf_range(-plot_size.x * 0.36, plot_size.x * 0.36)
		speck.position = center + Vector2(x_offset, plot_size.y * 0.30 + randf_range(-4.0, 5.0))
		speck.draw.connect(_draw_fertilizer_speck.bind(speck))
		overlay_layer.add_child(speck)
		var target := speck.position + Vector2(randf_range(-10.0, 10.0), randf_range(-24.0, -10.0))
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(speck, "position", target, 0.34 + randf_range(0.0, 0.12)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(speck, "modulate:a", 0.0, 0.22).set_delay(0.24)
		tween.set_parallel(false)
		tween.tween_callback(speck.queue_free)
	_play_ground_ripple(center + Vector2(0, plot_size.y * 0.31), Color("#9a6a36"))


func _play_ground_ripple(center: Vector2, color: Color) -> void:
	var ripple := _care_draw_node(Vector2(86, 28), 1701)
	ripple.position = center - ripple.size * 0.5
	ripple.draw.connect(_draw_ground_ripple.bind(ripple, color))
	overlay_layer.add_child(ripple)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(ripple, "scale", Vector2(1.22, 1.12), 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(ripple, "modulate:a", 0.0, 0.32).set_delay(0.18)
	tween.set_parallel(false)
	tween.tween_callback(ripple.queue_free)


func _care_draw_node(node_size: Vector2, node_z_index: int) -> Control:
	var node := Control.new()
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.size = node_size
	node.custom_minimum_size = node_size
	node.z_index = node_z_index
	return node


func _draw_water_drop(drop: Control) -> void:
	var fill := Color("#73cdf2")
	var shine := Color("#e6fbff")
	drop.draw_colored_polygon(PackedVector2Array([Vector2(7, 1), Vector2(13, 10), Vector2(10, 17), Vector2(4, 17), Vector2(1, 10)]), fill)
	drop.draw_circle(Vector2(7, 11), 6.0, fill)
	drop.draw_circle(Vector2(5, 8), 1.7, shine)


func _draw_sun_burst(burst: Control) -> void:
	var center := burst.size * 0.5
	var ray_color := Color(1.0, 0.76, 0.22, 0.52)
	var glow_color := Color(1.0, 0.88, 0.28, 0.28)
	for index in range(12):
		var angle := TAU * float(index) / 12.0
		var inner := center + Vector2(cos(angle), sin(angle)) * 23.0
		var outer := center + Vector2(cos(angle), sin(angle)) * 50.0
		burst.draw_line(inner, outer, ray_color, 3.0)
	burst.draw_circle(center, 30.0, glow_color)
	burst.draw_arc(center, 38.0, 0.0, TAU, 48, Color(1.0, 0.93, 0.42, 0.46), 2.0)
	burst.draw_circle(center, 13.0, Color(1.0, 0.84, 0.24, 0.78))


func _draw_fertilizer_speck(speck: Control) -> void:
	var soil := Color("#7b4f2c")
	var warm := Color("#c1904a")
	speck.draw_circle(Vector2(5, 5), 4.0, soil)
	speck.draw_circle(Vector2(3.5, 4.0), 1.4, warm)


func _draw_ground_ripple(ripple: Control, color: Color) -> void:
	var ring := color
	ring.a = 0.42
	ripple.draw_arc(ripple.size * 0.5, ripple.size.x * 0.38, 0.0, TAU, 42, ring, 3.0)


func _animate_plot_button(button: Button, plot: Dictionary) -> void:
	var feedback := _plant_feedback(plot)
	button.pivot_offset = Vector2(button.size.x * 0.5, button.size.y * PLOT_GROUND_ANCHOR_Y)
	var stage := str(plot.get("stage", ""))
	var amount := float(feedback.get("amount", 0.035 if stage in ["tree", "flower", "fruit", "bloom", "blossom"] else 0.018))
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
	var mature := stage in ["tree", "flower", "fruit", "bloom", "blossom"]
	var feedback := {
		"effect": "sway",
		"phase": randf(),
		"amount": randf_range(0.018, 0.04) if mature else randf_range(0.012, 0.02),
		"speed": randf_range(0.24, 0.43)
	}
	plant_feedback_by_id[plot_id] = feedback
	return feedback


func _render_decor_bar() -> void:
	_update_decor_mode_buttons()
	_update_bottom_move_button()
	for child in decor_bar.get_children():
		child.queue_free()

	if decor_mode == "seed_shop":
		_render_seed_shop_bar()
		return

	for decor in garden_data.get("decoration_catalog", []):
		var decor_id := str(decor.get("id", ""))
		var owned := _owned_count(decor.get("id", ""))
		var price := int(decor.get("price", 0))
		var is_shop := decor_mode == "shop"
		var can_buy := int(garden_data.get("coins", 0)) >= price
		var is_selected := decor_id == selected_decor_id and not is_shop
		var button := Button.new()
		button.custom_minimum_size = Vector2(60, 68)
		button.size = Vector2(60, 68)
		button.clip_text = true
		button.text = ""
		button.disabled = (not can_buy) if is_shop else owned <= 0
		button.tooltip_text = "购买%s" % decor.get("title", "装饰") if is_shop else "选择%s" % decor.get("title", "装饰")
		var fill := Color("#f2d486") if is_selected else (Color("#bfcf7a") if is_shop and can_buy else Color("#c79858"))
		var border := Color("#fff0a5") if is_selected else Color("#5c351b")
		button.add_theme_stylebox_override("normal", _tray_button_style(fill, border, 3 if is_selected else 2))
		button.add_theme_stylebox_override("hover", _tray_button_style(Color("#e6bd70"), Color("#fff4b6"), 3))
		button.add_theme_stylebox_override("pressed", _tray_button_style(Color("#b87739"), Color("#fff4b6"), 3))
		button.add_theme_stylebox_override("disabled", _tray_button_style(Color("#6e6650"), Color("#413827"), 2))
		button.modulate = Color(1, 1, 1, 1) if (can_buy if is_shop else owned > 0) else Color(0.58, 0.56, 0.50, 0.78)
		_add_button_texture(button, decor.get("sprite", ""))
		var count_label := Label.new()
		count_label.text = "%d金" % price if is_shop else "x%d" % owned
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
		if is_shop:
			button.pressed.connect(_buy_decoration.bind(decor_id))
		else:
			button.pressed.connect(_select_decoration.bind(decor_id))
		decor_bar.add_child(button)


func _render_seed_shop_bar() -> void:
	for kind in ["paper", "course"]:
		for variety in PLANT_VARIETIES.get(kind, []):
			var label := str((variety as Dictionary).get("label", "品种"))
			var base := str((variety as Dictionary).get("base", ""))
			var unlocked := _is_variety_unlocked(kind, base)
			var price := _variety_unlock_price(kind)
			var can_buy := int(garden_data.get("coins", 0)) >= price
			var button := Button.new()
			button.custom_minimum_size = Vector2(74, 68)
			button.size = Vector2(74, 68)
			button.clip_text = true
			button.text = ""
			button.disabled = unlocked or not can_buy
			button.tooltip_text = "%s已解锁" % label if unlocked else "解锁%s：%d金" % [label, price]
			var fill := Color("#d7d08a") if unlocked else (Color("#bfcf7a") if can_buy else Color("#7c7056"))
			button.add_theme_stylebox_override("normal", _tray_button_style(fill, Color("#5c351b"), 2))
			button.add_theme_stylebox_override("hover", _tray_button_style(Color("#e6bd70"), Color("#fff4b6"), 3))
			button.add_theme_stylebox_override("pressed", _tray_button_style(Color("#b87739"), Color("#fff4b6"), 3))
			button.add_theme_stylebox_override("disabled", _tray_button_style(fill, Color("#413827"), 2))
			button.modulate = Color(1, 1, 1, 1) if unlocked or can_buy else Color(0.58, 0.56, 0.50, 0.78)
			_add_button_texture(button, _web_stage_file_path("%s-seed" % base) if unlocked else SEED_LOCKED_ICON_SPRITE)
			var count_label := Label.new()
			count_label.text = "已解锁" if unlocked else "%d金" % price
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
			if not unlocked:
				button.pressed.connect(_buy_seed_variety.bind(kind, base))
			decor_bar.add_child(button)


func _update_decor_mode_buttons() -> void:
	if decor_inventory_button != null:
		var selected := decor_mode == "inventory"
		decor_inventory_button.add_theme_stylebox_override("normal", _tray_button_style(Color("#f2d486") if selected else Color("#9a6b38"), Color("#fff0a5") if selected else Color("#5c351b"), 2))
	if decor_shop_button != null:
		var selected := decor_mode == "shop"
		decor_shop_button.add_theme_stylebox_override("normal", _tray_button_style(Color("#f2d486") if selected else Color("#9a6b38"), Color("#fff0a5") if selected else Color("#5c351b"), 2))
	if seed_shop_button != null:
		var selected := decor_mode == "seed_shop"
		seed_shop_button.add_theme_stylebox_override("normal", _tray_button_style(Color("#f2d486") if selected else Color("#9a6b38"), Color("#fff0a5") if selected else Color("#5c351b"), 2))


func _update_bottom_move_button() -> void:
	if move_button == null:
		return
	var plot := _selected_plot()
	var can_move := selected_zone_id != "harvested" and not plot.is_empty() and str(plot.get("kind", "")) != "empty"
	move_button.visible = can_move
	move_button.disabled = not can_move
	move_button.add_theme_stylebox_override("normal", _tray_button_style(Color("#f2d486") if not moving_plot_id.is_empty() else Color("#9a6b38"), Color("#fff0a5") if not moving_plot_id.is_empty() else Color("#5c351b"), 2))
	move_button.add_theme_stylebox_override("disabled", _tray_button_style(Color("#6e6650"), Color("#413827"), 2))


func _set_decor_mode(mode: String) -> void:
	if mode != "inventory" and mode != "shop" and mode != "seed_shop":
		return
	decor_mode = mode
	if decor_mode == "shop" or decor_mode == "seed_shop":
		selected_decor_id = ""
		moving_decoration_index = -1
		_hide_decor_action_panel()
	_render_all()


func _buy_decoration(decor_id: String) -> void:
	var decor := _decor_by_id(decor_id)
	if decor.is_empty():
		return
	var price := int(decor.get("price", 0))
	if int(garden_data.get("coins", 0)) < price:
		return
	garden_data["coins"] = int(garden_data.get("coins", 0)) - price
	var owned: Dictionary = garden_data.get("owned_decorations", {})
	owned[decor_id] = int(owned.get(decor_id, 0)) + 1
	garden_data["owned_decorations"] = owned
	decor_mode = "inventory"
	selected_decor_id = decor_id
	selected_decoration_index = -1
	moving_decoration_index = -1
	_save_data()
	_render_all()


func _buy_seed_variety(kind: String, base: String) -> void:
	if _is_variety_unlocked(kind, base):
		return
	var price := _variety_unlock_price(kind)
	if int(garden_data.get("coins", 0)) < price:
		return
	garden_data["coins"] = int(garden_data.get("coins", 0)) - price
	var unlocked: Dictionary = garden_data.get("unlocked_varieties", {})
	var bases: Array = unlocked.get(kind, [])
	if not bases.has(base):
		bases.append(base)
	unlocked[kind] = bases
	garden_data["unlocked_varieties"] = unlocked
	_save_data()
	_render_all()


func _update_hint() -> void:
	if debug_mode:
		hint_label.text = "DEBUG: drag items. [ / ] resize. \\ export. F2 exit."
	elif not moving_plot_id.is_empty():
		hint_label.text = "选择目标地块来移动植物"
	elif moving_decoration_index >= 0:
		hint_label.text = "选择发光位置来移动装饰"
	elif not selected_decor_id.is_empty():
		var decor := _decor_by_id(selected_decor_id)
		hint_label.text = "把%s放到发光位置" % decor.get("title", "装饰")
	elif decor_mode == "shop":
		hint_label.text = "在商店用金币购买装饰，买到的装饰会进仓库"
	elif decor_mode == "seed_shop":
		hint_label.text = "在种子商店用金币解锁品种；解锁后点空地种植"
	elif selected_decoration_index >= 0:
		hint_label.text = "选择移动或收回装饰"
	else:
		var settlement_line := _settlement_hint_line()
		hint_label.text = settlement_line if not settlement_line.is_empty() else "轻点植物、装饰或小屋"


func _settlement_hint_line() -> String:
	var summary: Dictionary = garden_data.get("last_settlement_summary", {})
	var coins := int(summary.get("coins", 0))
	var growth := int(summary.get("growth", 0))
	if coins <= 0 and growth <= 0:
		return ""
	return "今日结算：+%d金币 / +%d成长" % [coins, growth]


func _on_harvested_prev_page() -> void:
	harvested_page_index = maxi(0, harvested_page_index - 1)
	selected_plot_id = ""
	moving_plot_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_render_all()


func _on_harvested_next_page() -> void:
	harvested_page_index = mini(_harvested_page_count(_current_zone().get("plots", []).size()) - 1, harvested_page_index + 1)
	selected_plot_id = ""
	moving_plot_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_render_all()


func _clamped_harvested_page_index(plot_count: int) -> int:
	return clampi(harvested_page_index, 0, _harvested_page_count(plot_count) - 1)


func _harvested_page_count(plot_count: int) -> int:
	return maxi(1, int(ceil(float(plot_count) / float(HARVESTED_PAGE_SIZE))))


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
		debug_drag_button.position = _map_point(map_rect, ratio) - Vector2(item_size.x * 0.5, item_size.y)
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
	moving_plot_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
	if selected_zone_id == "harvested":
		harvested_page_index = _clamped_harvested_page_index(_current_zone().get("plots", []).size())
	_update_zone_audio()
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_save_data()
	_render_all()


func _select_plot(plot_id: String) -> void:
	selected_decor_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
	_hide_decor_action_panel()
	_hide_record_panel()
	_hide_record_history_panel()
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return
	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	if not moving_plot_id.is_empty():
		_move_plot_in_current_zone(moving_plot_id, plot_id)
		return

	selected_plot_id = plot_id
	for index in plots.size():
		if plots[index].get("id", "") == plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				if _can_plant_in_current_zone():
					_save_data()
					_show_plant_panel()
					_render_decor_bar()
					call_deferred("_render_map")
				else:
					_hide_plant_panel()
					_save_data()
					_render_detail()
					_render_decor_bar()
					call_deferred("_render_map")
				return
			_hide_plant_panel()
			plots[index]["visits"] = int(plots[index].get("visits", 0)) + 1
			garden_data["zones"][zone_index]["plots"] = plots
			break
	_save_data()
	_render_detail()
	_render_decor_bar()
	call_deferred("_render_map")


func _move_plot_in_current_zone(first_plot_id: String, second_plot_id: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or first_plot_id == second_plot_id:
		moving_plot_id = ""
		_render_all()
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	var first_index := _plot_index_in_array(plots, first_plot_id)
	var second_index := _plot_index_in_array(plots, second_plot_id)
	if first_index < 0 or second_index < 0:
		return
	if str(plots[first_index].get("kind", "")) == "empty":
		return

	if selected_zone_id == "harvested":
		var first_plot: Dictionary = plots[first_index]
		plots[first_index] = plots[second_index]
		plots[second_index] = first_plot
	else:
		var first_x := float(plots[first_index].get("x", 0.5))
		var first_y := float(plots[first_index].get("y", 0.5))
		plots[first_index]["x"] = plots[second_index].get("x", 0.5)
		plots[first_index]["y"] = plots[second_index].get("y", 0.5)
		plots[second_index]["x"] = first_x
		plots[second_index]["y"] = first_y

	garden_data["zones"][zone_index]["plots"] = plots
	selected_plot_id = first_plot_id
	selected_decor_id = ""
	moving_plot_id = ""
	_hide_plant_panel()
	_save_data()
	_render_all()


func _plot_index_in_array(plots: Array, plot_id: String) -> int:
	for index in plots.size():
		if str(plots[index].get("id", "")) == plot_id:
			return index
	return -1


func _plot_from_array(plots: Array, plot_id: String) -> Dictionary:
	var index := _plot_index_in_array(plots, plot_id)
	if index < 0:
		return {}
	return plots[index]


func _close_detail() -> void:
	selected_plot_id = ""
	moving_plot_id = ""
	if detail_panel != null:
		detail_panel.visible = false
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_render_decor_bar()
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
	_show_plant_varieties("")
	plant_panel.visible = not selected_plot_id.is_empty()


func _hide_plant_panel() -> void:
	if plant_panel != null:
		plant_panel.visible = false


func _show_plant_varieties(kind: String) -> void:
	if plant_variety_grid == null:
		return
	for child in plant_variety_grid.get_children():
		child.queue_free()
	if kind.is_empty():
		plant_variety_label.text = "先选择一个类别"
		return
	plant_variety_label.text = "选择%s品种；锁定品种请到底部种子商店解锁" % _kind_label(kind)
	for variety in PLANT_VARIETIES.get(kind, []):
		_plant_variety_button(kind, variety, plant_variety_grid)


func _unlocked_variety_bases(kind: String) -> Array:
	var unlocked: Dictionary = garden_data.get("unlocked_varieties", {})
	var bases: Array = unlocked.get(kind, [])
	return bases.duplicate()


func _is_variety_unlocked(kind: String, base: String) -> bool:
	return _unlocked_variety_bases(kind).has(base)


func _extra_unlocked_variety_count(kind: String) -> int:
	return maxi(0, _unlocked_variety_bases(kind).size() - INITIAL_UNLOCKED_VARIETY_COUNT)


func _variety_unlock_price(kind: String) -> int:
	return EconomyRules.variety_unlock_price(kind, _extra_unlocked_variety_count(kind))


func _unlock_variety(kind: String, base: String) -> void:
	if _is_variety_unlocked(kind, base):
		_show_plant_varieties(kind)
		return
	var price := _variety_unlock_price(kind)
	if int(garden_data.get("coins", 0)) < price:
		return
	garden_data["coins"] = int(garden_data.get("coins", 0)) - price
	var unlocked: Dictionary = garden_data.get("unlocked_varieties", {})
	var bases: Array = unlocked.get(kind, [])
	if not bases.has(base):
		bases.append(base)
	unlocked[kind] = bases
	garden_data["unlocked_varieties"] = unlocked
	_save_data()
	_update_header()
	_show_plant_varieties(kind)


func _plant_empty_plot(kind: String, variety_base := "", variety_label := "") -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty() or not _can_plant_in_current_zone():
		return
	if not variety_base.is_empty() and not _is_variety_unlocked(kind, variety_base):
		return
	if variety_base.is_empty():
		var varieties: Array = PLANT_VARIETIES.get(kind, [])
		if varieties.is_empty():
			return
		variety_base = str((varieties[0] as Dictionary).get("base", ""))
		variety_label = str((varieties[0] as Dictionary).get("label", ""))

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") != selected_plot_id:
			continue
		var plot: Dictionary = plots[index]
		if str(plot.get("kind", "")) != "empty":
			return
		plot["kind"] = kind
		plot["stage"] = "seed"
		plot["title"] = "%s%s" % [variety_label, _kind_label(kind)] if not variety_label.is_empty() else ("New Paper Tree" if kind == "paper" else "New Course Flower")
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
		var stage := "seed"
		var file_base := "%s-%s" % [variety_base, stage]
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


func _care_type_for_record_slot(slot_index: int) -> String:
	var record_care_types := ["water", "sun", "fertilizer"]
	return str(record_care_types[clampi(slot_index, 0, record_care_types.size() - 1)])


func _least_care_type(plot: Dictionary) -> String:
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	var result := "water"
	var result_amount := int(care.get(result, 0))
	for care_type in CARE_TYPES:
		var amount := int(care.get(str(care_type), 0))
		if amount < result_amount:
			result = str(care_type)
			result_amount = amount
	return result


func _grant_care(plot: Dictionary, care_type: String, amount := 1) -> int:
	var normalized_type := care_type if CARE_TYPES.has(care_type) else "water"
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	care[normalized_type] = int(care.get(normalized_type, 0)) + amount
	plot["care_today"] = care
	return amount


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


func _grant_random_care(plot: Dictionary) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var types := CARE_TYPES.duplicate()
	types.shuffle()
	var care: Dictionary = plot.get("care_today", {"sun": 0, "water": 0, "fertilizer": 0})
	var award_count := 2 if rng.randf() < RANDOM_DOUBLE_CARE_CHANCE else 1
	for index in range(award_count):
		var care_type := str(types[index])
		care[care_type] = int(care.get(care_type, 0)) + 1
	plot["care_today"] = care


func _record_action(action_text: String, slot_index: int) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty() or selected_zone_id != "active":
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = action_text
			var care_type := _care_type_for_record_slot(slot_index)
			_grant_care(plots[index], care_type)
			if str(plots[index].get("kind", "")) == "course" and slot_index == 1:
				plots[index]["sessions"] = int(plots[index].get("sessions", 0)) + 1
			_append_plot_record_history(plots[index], action_text, "quick")
			garden_data["zones"][zone_index]["plots"] = plots
			call_deferred("_play_care_feedback_for_selected_plot", care_type, 1)
			break
	_save_data()
	_hide_record_panel()
	_hide_record_history_panel()
	_render_detail()
	_render_map()


func _record_care(care_type: String, status_text: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty() or selected_zone_id != "active":
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = status_text
			_grant_care(plots[index], care_type)
			if str(plots[index].get("kind", "")) == "course" and care_type == "water":
				plots[index]["sessions"] = int(plots[index].get("sessions", 0)) + 1
			_append_plot_record_history(plots[index], status_text, "care")
			garden_data["zones"][zone_index]["plots"] = plots
			call_deferred("_play_care_feedback_for_selected_plot", care_type, 1)
			break
	_save_data()
	_hide_record_panel()
	_hide_record_history_panel()
	_render_detail()
	_render_map()


func _record_note(note_text: String) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty() or selected_zone_id != "active":
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == selected_plot_id:
			if str(plots[index].get("kind", "")) == "empty":
				return
			plots[index]["logs"] = int(plots[index].get("logs", 0)) + 1
			plots[index]["status"] = "Recorded"
			plots[index]["note"] = note_text
			var care_type := _least_care_type(plots[index])
			_grant_care(plots[index], care_type)
			_append_plot_record_history(plots[index], note_text, "note")
			garden_data["zones"][zone_index]["plots"] = plots
			call_deferred("_play_care_feedback_for_selected_plot", care_type, 1)
			break
	_save_data()
	_hide_record_panel()
	_hide_record_history_panel()
	_render_detail()
	_render_map()


func _on_advance_pressed() -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0 or selected_plot_id.is_empty() or selected_zone_id != "active":
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


func _on_move_plot_pressed() -> void:
	if selected_zone_id == "harvested":
		return
	var plot := _selected_plot()
	if plot.is_empty() or str(plot.get("kind", "")) == "empty":
		return
	moving_plot_id = selected_plot_id
	selected_decor_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
	if detail_panel != null:
		detail_panel.visible = false
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_render_all()


func _on_remove_pressed() -> void:
	if selected_zone_id == "harvested":
		return
	_show_remove_confirmation()


func _show_remove_confirmation() -> void:
	if selected_zone_id == "harvested":
		return
	var plot := _selected_plot()
	if plot.is_empty() or str(plot.get("kind", "")) == "empty":
		return

	pending_remove_zone_id = selected_zone_id
	pending_remove_plot_id = selected_plot_id
	if remove_confirm_overlay == null:
		_confirm_remove_selected_plot()
		return

	if remove_confirm_body_label != null:
		remove_confirm_body_label.text = "确定要移除「%s」吗？\n这个位置会恢复为空地，可以重新种植。" % _display_title(plot)
	remove_confirm_overlay.visible = true
	_update_remove_confirm_layout()


func _confirm_remove_selected_plot() -> void:
	var zone_id := pending_remove_zone_id
	var plot_id := pending_remove_plot_id
	if remove_confirm_overlay != null:
		remove_confirm_overlay.visible = false
	pending_remove_zone_id = ""
	pending_remove_plot_id = ""
	if zone_id.is_empty() or plot_id.is_empty():
		return

	var zone_index := _zone_index_by_id(zone_id)
	if zone_index < 0:
		return

	var plots: Array = garden_data["zones"][zone_index].get("plots", [])
	for index in plots.size():
		if plots[index].get("id", "") == plot_id and str(plots[index].get("kind", "")) != "empty":
			var plot: Dictionary = plots[index]
			_reset_plot_to_empty(plot)
			plots[index] = plot
			break
	garden_data["zones"][zone_index]["plots"] = plots
	if selected_plot_id == plot_id:
		selected_plot_id = ""
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_save_data()
	_render_all()


func _reset_plot_to_empty(plot: Dictionary) -> void:
	plot["title"] = "Empty Plot"
	plot["kind"] = "empty"
	plot["stage"] = "empty"
	plot["status"] = "Available"
	plot["note"] = "Quiet land for parked ideas."
	plot["sprite"] = ""
	plot["visits"] = 0
	plot["logs"] = 0
	plot.erase("portrait_sprite")
	plot.erase("growth")
	plot.erase("care_today")
	plot.erase("quick_record_labels")
	plot.erase("record_history")
	plot.erase("sessions")


func _select_decoration(decor_id: String) -> void:
	selected_plot_id = ""
	selected_decor_id = decor_id
	selected_decoration_index = -1
	moving_plot_id = ""
	moving_decoration_index = -1
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	_hide_decor_action_panel()
	_render_detail()
	call_deferred("_render_map")


func _select_placed_decoration(decor_index: int) -> void:
	var decoration := _decoration_by_index(decor_index)
	if decoration.is_empty():
		return
	selected_plot_id = ""
	selected_decor_id = ""
	moving_plot_id = ""
	moving_decoration_index = -1
	selected_decoration_index = decor_index
	_hide_record_panel()
	_hide_record_history_panel()
	_hide_plant_panel()
	if detail_panel != null:
		detail_panel.visible = false
	if decor_action_title != null:
		var decor := _decor_by_id(str(decoration.get("id", "")))
		decor_action_title.text = decor.get("title", "装饰")
	if decor_action_panel != null:
		decor_action_panel.visible = true
	call_deferred("_render_map")


func _hide_decor_action_panel() -> void:
	if decor_action_panel != null:
		decor_action_panel.visible = false
	selected_decoration_index = -1
	if moving_decoration_index < 0:
		call_deferred("_render_map")


func _on_move_decoration_pressed() -> void:
	if selected_decoration_index < 0:
		return
	moving_decoration_index = selected_decoration_index
	selected_decoration_index = -1
	if decor_action_panel != null:
		decor_action_panel.visible = false
	_render_all()


func _on_reclaim_decoration_pressed() -> void:
	if selected_decoration_index < 0:
		return
	_remove_decoration_at_index(selected_decoration_index)


func _on_decor_slot_pressed(slot_index: int) -> void:
	if moving_decoration_index >= 0:
		_move_decoration_to_slot(moving_decoration_index, slot_index)
	else:
		_place_selected_decoration(slot_index)


func _place_selected_decoration(slot_index: int) -> void:
	if selected_decor_id.is_empty() or _owned_count(selected_decor_id) <= 0:
		return

	var zone_index := _current_zone_index()
	if zone_index < 0:
		return

	var slot: Vector2 = DECOR_SLOTS[slot_index]
	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	decorations.append({"id": selected_decor_id, "x": slot.x, "y": slot.y, "size_scale": _decor_default_scale(selected_decor_id)})
	garden_data["zones"][zone_index]["decorations"] = decorations
	garden_data["owned_decorations"][selected_decor_id] = _owned_count(selected_decor_id) - 1
	selected_decor_id = ""
	_save_data()
	_render_all()


func _move_decoration_to_slot(decor_index: int, slot_index: int) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return

	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	if decor_index < 0 or decor_index >= decorations.size():
		moving_decoration_index = -1
		_render_all()
		return

	var slot: Vector2 = DECOR_SLOTS[slot_index]
	var placed: Dictionary = decorations[decor_index]
	placed["x"] = slot.x
	placed["y"] = slot.y
	decorations[decor_index] = placed
	garden_data["zones"][zone_index]["decorations"] = decorations
	moving_decoration_index = -1
	selected_decoration_index = -1
	_save_data()
	_render_all()


func _remove_decoration_at_index(decor_index: int) -> void:
	var zone_index := _current_zone_index()
	if zone_index < 0:
		return

	var decorations: Array = garden_data["zones"][zone_index].get("decorations", [])
	if decor_index < 0 or decor_index >= decorations.size():
		return
	var placed: Dictionary = decorations[decor_index]
	var decor_id: String = placed.get("id", "")
	decorations.remove_at(decor_index)
	garden_data["owned_decorations"][decor_id] = _owned_count(decor_id) + 1
	garden_data["zones"][zone_index]["decorations"] = decorations
	selected_decor_id = ""
	selected_decoration_index = -1
	moving_decoration_index = -1
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

	var moved_plot := plot.duplicate(true)
	var source_plots: Array = garden_data["zones"][source_zone_index].get("plots", [])
	for index in source_plots.size():
		if source_plots[index].get("id", "") == plot.get("id", ""):
			var empty_plot: Dictionary = source_plots[index]
			_reset_plot_to_empty(empty_plot)
			source_plots[index] = empty_plot
			break
	garden_data["zones"][source_zone_index]["plots"] = source_plots

	var target_plots: Array = garden_data["zones"][target_zone_index].get("plots", [])
	var empty_target_index := _first_empty_plot_index(target_plots)
	if empty_target_index >= 0:
		var empty_target: Dictionary = target_plots[empty_target_index]
		moved_plot["id"] = str(empty_target.get("id", _next_zone_plot_id(target_zone_id, target_plots)))
	else:
		moved_plot["id"] = _next_zone_plot_id(target_zone_id, target_plots)
	var anchor: Vector2 = PLOT_ANCHORS.get(moved_plot["id"], Vector2(0.5, 0.64))
	moved_plot["x"] = anchor.x
	moved_plot["y"] = anchor.y
	moved_plot["size_scale"] = PLOT_SIZE_SCALES.get(moved_plot["id"], float(moved_plot.get("size_scale", 1.0)))
	if empty_target_index >= 0:
		target_plots[empty_target_index] = moved_plot
	else:
		target_plots.append(moved_plot)
	garden_data["zones"][target_zone_index]["plots"] = target_plots
	selected_zone_id = target_zone_id
	selected_plot_id = moved_plot["id"]
	selected_decor_id = ""
	if target_zone_id == "harvested":
		harvested_page_index = _harvested_page_count(target_plots.size()) - 1


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
	for index in range(1, plots.size() + 2):
		var candidate := "%s-%d" % [zone_id, index]
		if not used.has(candidate):
			return candidate
	return "%s-%d" % [zone_id, plots.size() + 1]


func _first_empty_plot_index(plots: Array) -> int:
	for index in plots.size():
		if str(plots[index].get("kind", "")) == "empty":
			return index
	return -1


func _update_detail_actions(plot: Dictionary) -> void:
	var kind := str(plot.get("kind", ""))
	var is_empty := kind == "empty"
	var is_active := selected_zone_id == "active"
	var is_dormant := selected_zone_id == "dormant"
	var is_harvested := selected_zone_id == "harvested"
	log_button.text = "记录"
	history_button.text = "查看记录"
	teach_button.text = "快捷%s" % CARE_LABELS.get("water", "水")
	advance_button.text = _next_action_label(plot)
	move_button.text = "移动"
	sleep_button.text = "暂时休眠"
	wake_button.text = "唤醒"
	remove_button.text = "移除"
	log_button.disabled = is_empty or not is_active
	history_button.disabled = is_empty
	teach_button.disabled = is_empty or kind != "course" or not is_active
	advance_button.disabled = is_empty or not is_active or _next_stage(plot).is_empty()
	move_button.disabled = is_empty or is_harvested
	sleep_button.disabled = is_empty or not is_active
	wake_button.disabled = is_empty or not is_dormant
	remove_button.disabled = is_empty or is_harvested
	_apply_detail_action_tones()
	_detail_panel_action_visibility(is_active and not is_empty, is_active and not is_empty, is_dormant and not is_empty, not is_empty and not is_active and not is_harvested, is_active and not is_empty)
	if is_empty:
		log_button.text = "稍后种植"
		history_button.text = "暂无记录"
		teach_button.text = "选择类型"
		advance_button.text = "暂无阶段"
		move_button.text = "空地"
		sleep_button.text = "预留"
		wake_button.text = "预留"
		remove_button.text = "空地"
		_detail_panel_action_visibility(false, false, false, false)


func _apply_detail_action_tones() -> void:
	_apply_button_tone(log_button, UI_TONE_PRIMARY)
	_apply_button_tone(history_button, UI_TONE_NEUTRAL)
	_apply_button_tone(teach_button, UI_TONE_PRIMARY)
	_apply_button_tone(advance_button, UI_TONE_PRIMARY)
	_apply_button_tone(sleep_button, UI_TONE_SLEEP)
	_apply_button_tone(wake_button, UI_TONE_PRIMARY)
	_apply_button_tone(remove_button, UI_TONE_DANGER)


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
	return PlantRules.next_stage(str(plot.get("kind", "")), str(plot.get("stage", "")))


func _is_final_stage(plot: Dictionary) -> bool:
	return PlantRules.is_final_stage(str(plot.get("kind", "")), str(plot.get("stage", "")))


func _set_plot_stage_sprites(plot: Dictionary) -> void:
	var base := _plant_variety_base(plot)
	if base.is_empty():
		return
	var stage := str(plot.get("stage", ""))
	var file_base := "%s-%s" % [base, stage]
	plot["sprite"] = _web_stage_file_path(file_base)
	plot["portrait_sprite"] = plot["sprite"]


func _plant_variety_base(plot: Dictionary) -> String:
	return PlantRules.plant_variety_base(plot)


func _default_growth_for_stage(plot: Dictionary) -> int:
	return PlantRules.default_growth_for_stage(plot, MILESTONE_GROWTH)


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


func _can_plant_in_zone(zone_id: String) -> bool:
	return PLANTABLE_ZONE_IDS.has(zone_id)


func _can_plant_in_current_zone() -> bool:
	return _can_plant_in_zone(selected_zone_id)


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


func _decor_default_scale(decor_id: String) -> float:
	return float(DECOR_SIZE_SCALES.get(decor_id, 1.0))


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
	return _plot_button_base_size(plot) * PLANT_MAP_SCALE


func _plot_button_base_size(plot: Dictionary) -> Vector2:
	var kind := str(plot.get("kind", "course"))
	var stage := str(plot.get("stage", ""))
	var stage_key := "%s:%s" % [kind, stage]
	var base: Vector2 = STAGE_PLOT_SIZES.get(stage_key, DEFAULT_PLOT_SIZES.get(kind, DEFAULT_PLOT_SIZES["course"]))
	return base * float(plot.get("size_scale", 1.0))


func _plot_button_position(map_rect: Rect2, plot: Dictionary, button_size: Vector2) -> Vector2:
	var anchor := _map_point(map_rect, Vector2(plot.get("x", 0.5), plot.get("y", 0.5)))
	var base_size := _plot_button_base_size(plot)
	var original_bottom_y := anchor.y + base_size.y * (1.0 - PLOT_GROUND_ANCHOR_Y)
	return Vector2(anchor.x - button_size.x * 0.5, original_bottom_y - button_size.y)


func _decor_button_size(placed: Dictionary) -> Vector2:
	var decor_scale := float(placed.get("size_scale", 1.0))
	return DEFAULT_DECOR_SIZE * decor_scale * _foreground_depth_scale(float(placed.get("y", 0.5)))


func _foreground_depth_scale(y_ratio: float) -> float:
	var t := clampf((y_ratio - 0.42) / 0.36, 0.0, 1.0)
	return lerpf(0.94, 1.08, t)


func _add_contact_shadow(button: Button, object_size: Vector2, width_ratio := 0.58, alpha := 0.34, y_ratio := 0.78, height_ratio := 0.075) -> void:
	var shadow := PanelContainer.new()
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.size = Vector2(object_size.x * width_ratio, maxf(4.0, object_size.y * height_ratio))
	shadow.position = Vector2((object_size.x - shadow.size.x) * 0.5, object_size.y * y_ratio)
	shadow.add_theme_stylebox_override("panel", _contact_shadow_style(alpha))
	button.add_child(shadow)


func _add_empty_plot_guide(button: Button, object_size: Vector2) -> void:
	var guide := Control.new()
	guide.mouse_filter = Control.MOUSE_FILTER_IGNORE
	guide.size = Vector2(object_size.x * 0.70, object_size.y * 0.42)
	guide.position = Vector2((object_size.x - guide.size.x) * 0.5, object_size.y * 0.54)
	guide.draw.connect(_draw_empty_plot_guide.bind(guide))
	button.add_child(guide)


func _draw_empty_plot_guide(guide: Control) -> void:
	var color := Color("#fff0a5")
	color.a = 0.86
	var plus_color := Color("#fff7bd")
	plus_color.a = 0.56
	var inset := Vector2(8.0, 7.0)
	var rect := Rect2(inset, guide.size - inset * 2.0)
	_draw_dashed_line(guide, rect.position, rect.position + Vector2(rect.size.x, 0.0), color, 2.0, 7.0, 5.0)
	_draw_dashed_line(guide, rect.position + Vector2(rect.size.x, 0.0), rect.position + rect.size, color, 2.0, 7.0, 5.0)
	_draw_dashed_line(guide, rect.position + rect.size, rect.position + Vector2(0.0, rect.size.y), color, 2.0, 7.0, 5.0)
	_draw_dashed_line(guide, rect.position + Vector2(0.0, rect.size.y), rect.position, color, 2.0, 7.0, 5.0)
	var center := guide.size * 0.5
	guide.draw_line(center + Vector2(-8.0, 0.0), center + Vector2(8.0, 0.0), plus_color, 2.0)
	guide.draw_line(center + Vector2(0.0, -8.0), center + Vector2(0.0, 8.0), plus_color, 2.0)


func _draw_dashed_line(canvas: Control, start: Vector2, end: Vector2, color: Color, width: float, dash: float, gap: float) -> void:
	var delta := end - start
	var length := delta.length()
	if length <= 0.0:
		return
	var direction := delta / length
	var cursor := 0.0
	while cursor < length:
		var segment_end := minf(cursor + dash, length)
		canvas.draw_line(start + direction * cursor, start + direction * segment_end, color, width)
		cursor += dash + gap


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
		"platform": _runtime_platform_name(),
		"platform_android": OS.has_feature("android"),
		"platform_ios": OS.has_feature("ios"),
		"platform_mobile": _is_mobile_runtime(),
		"viewport_size": get_viewport_rect().size,
		"window_size": DisplayServer.window_get_size(),
		"safe_area": safe_area,
		"root_offsets": Vector4(root_box.offset_left, root_box.offset_top, root_box.offset_right, root_box.offset_bottom) if root_box != null else Vector4.ZERO,
		"map_canvas_size": map_canvas.size if map_canvas != null else Vector2.ZERO,
		"map_rect": map_rect,
		"user_data_dir": ProjectSettings.globalize_path("user://"),
		"save_path": ProjectSettings.globalize_path(SAVE_PATH)
	}


func _runtime_platform_name() -> String:
	if OS.has_feature("android"):
		return "android"
	if OS.has_feature("ios"):
		return "ios"
	return OS.get_name().to_lower()


func _is_mobile_runtime() -> bool:
	return OS.has_feature("android") or OS.has_feature("ios")


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


func _add_button_texture(button: Button, path: String, sprite_filter := {}, stretch_mode := TextureRect.STRETCH_KEEP_ASPECT_CENTERED) -> void:
	var icon := TextureRect.new()
	icon.texture = _load_texture(path)
	icon.material = _sprite_filter_material(sprite_filter)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = stretch_mode
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
		if not _texture_resource_exists(frame_path):
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
	return PlantRules.web_stage_sprite_path(plot)


func _web_stage_file_path(file_base: String) -> String:
	var normalized_path := PlantRules.web_stage_file_path(file_base)
	if _texture_resource_exists(normalized_path):
		return normalized_path
	push_warning("Missing normalized stage sprite: %s" % normalized_path)
	return normalized_path


func _texture_resource_exists(path: String) -> bool:
	return ResourceLoader.exists(path, "Texture2D") or ResourceLoader.exists(path)


func _plant_sprite_base(path: String) -> String:
	return PlantRules.plant_sprite_base(path)
