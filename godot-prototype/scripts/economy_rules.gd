extends RefCounted

const FLOWER_VARIETY_UNLOCK_PRICE := 150
const TREE_VARIETY_UNLOCK_BASE_PRICE := 240
const DAILY_GROWTH_CAP := 18
const DAILY_COIN_GROWTH_UNIT := 18.0
const DAILY_COIN_BASE := 6.0
const DAILY_COIN_RANDOM_MIN := 0.95
const DAILY_COIN_RANDOM_MAX := 1.05
const DAILY_COIN_PLANT_CAP := 30
const STAGE_COIN_MULTIPLIERS := {
	"seed": 0.70,
	"sapling": 0.90,
	"tree": 1.15,
	"flower": 1.45,
	"fruit": 1.80,
	"seedling": 0.90,
	"bud": 1.15,
	"bloom": 1.45,
	"blossom": 1.80
}


static func daily_growth_from_care(care: Dictionary) -> int:
	var water := int(care.get("water", 0))
	var sun := int(care.get("sun", 0))
	var fertilizer := int(care.get("fertilizer", 0))
	var total := water + sun + fertilizer
	if total <= 0:
		return 0
	var diversity := 0
	for amount in [water, sun, fertilizer]:
		if amount > 0:
			diversity += 1
	var balanced_bonus := mini(water, mini(sun, fertilizer))
	return mini(DAILY_GROWTH_CAP, int(round(3.0 * total + 2.0 * maxi(0, diversity - 1) + 2.0 * balanced_bonus)))


static func daily_coin_random_min() -> float:
	return DAILY_COIN_RANDOM_MIN


static func daily_coin_random_max() -> float:
	return DAILY_COIN_RANDOM_MAX


static func daily_coins_for_plot_with_factor(plot: Dictionary, random_factor: float) -> int:
	var growth := maxi(0, int(plot.get("growth", 0)))
	if growth <= 0:
		return 0
	var stage := str(plot.get("stage", ""))
	var multiplier := float(STAGE_COIN_MULTIPLIERS.get(stage, 1.0))
	var base := DAILY_COIN_BASE * log(1.0 + float(growth) / DAILY_COIN_GROWTH_UNIT)
	return mini(DAILY_COIN_PLANT_CAP, maxi(0, int(round(base * multiplier * random_factor))))


static func variety_unlock_price(kind: String, extra_unlocked_count: int) -> int:
	if kind == "paper":
		return int(TREE_VARIETY_UNLOCK_BASE_PRICE * pow(2.0, float(maxi(0, extra_unlocked_count))))
	return FLOWER_VARIETY_UNLOCK_PRICE
