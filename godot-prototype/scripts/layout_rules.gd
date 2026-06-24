extends RefCounted

const HARVESTED_PAGE_SIZE := 9
const MAP_DISPLAY_ASPECT := 780.0 / 1240.0
const ROOT_MARGIN_PX := 10.0
const DEFAULT_PLOT_SIZES := {
	"paper": Vector2(96, 108),
	"course": Vector2(88, 98),
	"empty": Vector2(96, 74)
}
const STAGE_PLOT_SIZES := {
	"paper:seed": Vector2(54, 72),
	"paper:sapling": Vector2(78, 112),
	"paper:tree": Vector2(148, 184),
	"paper:flower": Vector2(148, 184),
	"paper:fruit": Vector2(148, 184),
	"course:seed": Vector2(42, 50),
	"course:seedling": Vector2(76, 94),
	"course:bud": Vector2(104, 128),
	"course:bloom": Vector2(104, 128),
	"course:blossom": Vector2(104, 128)
}
const DEFAULT_DECOR_SIZE := Vector2(68, 68)
const PLOT_GROUND_ANCHOR_Y := 0.90
const PLANT_MAP_SCALE := 0.49
const DECOR_SIZE_SCALES := {
	"path": 0.86,
	"bench": 0.82,
	"lamp": 0.92,
	"pond": 0.86,
	"well": 0.90,
	"workbench": 0.84,
	"sign": 0.82,
	"flower-rock": 0.86,
	"bridge": 0.86,
	"picnic": 0.86
}
