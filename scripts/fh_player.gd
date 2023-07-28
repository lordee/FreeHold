extends Node
class_name fh_player

var resources: fh_resources = fh_resources.new()
@onready var game: fh_game = get_node("/root/game")
@onready var happiness: float = game.settings.default_happiness

var castle: fh_entity

var population: int = 0
var population_max: int = 0
var work_population: int = 0
var last_spawn_time: float = 0
var warehouse_count: int = 0
var _barracks_count: int = 0
var barracks_count: int:
	get:
		return _barracks_count
	set(value):
		if value <= 0:
			game.ui_manager.enable_unit_buttons(false)
		else:
			game.ui_manager.enable_unit_buttons(true)
		_barracks_count = value
		

@onready var tax_rate: int = game.settings.tax_rate_min

func _ready():
	resources.set_resource(Enums.ENTITY.RESOURCE_WOODEN_PLANKS, 300)
	resources.set_resource(Enums.ENTITY.RESOURCE_GOLD, 0)

# TODO - accessors?
# we have changed to immediate mode for ui anyway so meh
func add_population_max(pop_num: int, adding: bool):
	if adding:
		population_max += pop_num
	else:
		population_max -= pop_num

func tax_rate_change(increase_tax: bool) -> bool:
	if increase_tax:
		if tax_rate < game.settings.tax_rate_max:
			tax_rate += 1
			return true
	else:
		if tax_rate > game.settings.tax_rate_min:
			tax_rate -= 1
			return true
	return false

func get_tax_income() -> float:
	var tax_amount: float = work_population * tax_rate
	
	return tax_amount
