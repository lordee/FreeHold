extends Node
class_name fh_ui_manager

var main_menu
@onready var ui = $ui
var base_container: GridContainer
var economy_container: GridContainer
var military_container: GridContainer

@onready var game: fh_game = get_node("/root/game")

# labels
@onready var resources_container: GridContainer = ui.get_node("ResourcesContainer")
@onready var wood_label: Label = resources_container.get_node("values_container").get_node("wood_label")
@onready var population_label: Label = resources_container.get_node("values_container").get_node("population_label")
@onready var gold_label: Label = resources_container.get_node("values_container").get_node("gold_label")
@onready var stone_label: Label = resources_container.get_node("values_container").get_node("stone_label")
@onready var iron_label: Label = resources_container.get_node("values_container").get_node("iron_label")
@onready var fruit_label: Label = resources_container.get_node("values_container").get_node("fruit_label")
@onready var vegetable_label: Label = resources_container.get_node("values_container").get_node("vegetable_label")
@onready var wheat_label: Label = resources_container.get_node("values_container").get_node("wheat_label")
@onready var happiness_label: Label = resources_container.get_node("values_container").get_node("happiness_label")
@onready var tax_container: GridContainer = ui.get_node("TaxContainerCenter/TaxContainer")
@onready var tax_label: Label = tax_container.get_node("tax_label")


func _ready():
	main_menu = $main_menu
	base_container = ui.get_node("CenterContainer/UIBaseContainer")
	base_container.get_node("economy").pressed.connect(economy_button_pressed)
	base_container.get_node("military").pressed.connect(military_button_pressed)
	economy_container = ui.get_node("CenterContainer/EconomyContainer")
	economy_container.get_node("warehouse").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_WAREHOUSE))
	economy_container.get_node("woodchopper").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_WOODCHOPPER))
	economy_container.get_node("quarry").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_QUARRY))
	economy_container.get_node("iron_mine").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_IRONMINE))
	economy_container.get_node("orchard").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_ORCHARD))
	economy_container.get_node("vegetable_farm").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_VEGETABLEFARM))
	economy_container.get_node("wheat_farm").pressed.connect(building_button_pressed.bind(Enums.ENTITY.BUILDING_WHEATFARM))
	economy_container.get_node("cancel").pressed.connect(ui_cancel_button_pressed)
	tax_container.get_node("tax_increase").pressed.connect(ui_tax_button_increased_pressed)
	tax_container.get_node("tax_decrease").pressed.connect(ui_tax_button_decreased_pressed)
#	military_container = ui.get_node("CenterContainer/MilitaryContainer")
	
func setup_ui():
	update_tax_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game.player_manager.current_player != null:
		population_label.text = str(game.player_manager.current_player.population) + "/" + str(game.player_manager.current_player.population_max)
		wood_label.text = str(game.player_manager.current_player.resources.wooden_planks)
		gold_label.text = str(game.player_manager.current_player.resources.gold) + " (+" + str(game.player_manager.current_player.get_tax_income()) + ")"
		happiness_label.text = str(game.player_manager.current_player.happiness)
		stone_label.text = str(game.player_manager.current_player.resources.stone)
		iron_label.text = str(game.player_manager.current_player.resources.iron)
		fruit_label.text = str(game.player_manager.current_player.resources.fruit)
		vegetable_label.text = str(game.player_manager.current_player.resources.vegetable)
		wheat_label.text = str(game.player_manager.current_player.resources.wheat)
	
# TODO - track button state/coords instead of constant node traversal
func button_recursive(node: Node, mouse_pos: Vector2) -> bool:
	for child in node.get_children():
		if child.visible:
			if button_hover_check(child, mouse_pos):
				return true
			if button_recursive(child, mouse_pos):
				return true
		
	return false
	
func button_hover_check(node: Node, mouse_pos: Vector2) -> bool:
	if node is Button:
		var rect: Rect2 = node.get_global_rect()		
		if mouse_pos.x >= rect.position.x and mouse_pos.x <= rect.position.x + rect.size.x:
			if mouse_pos.y >= rect.position.y and mouse_pos.y <= rect.position.y + rect.size.y:
				return true
	return false

func hovering_over_button(mouse_pos) -> bool:
	return button_recursive(self, mouse_pos)
	
func reset_ui_menus():
	ui_cancel_button_pressed()
	
# FIXME - one day we'll track this
func ui_cancel_button_pressed():
	base_container.visible = true
	economy_container.visible = false
	game.entity_manager.cancel_building_placement()

func building_button_pressed(entity_type: Enums.ENTITY):
	game.entity_manager.start_building_placement(entity_type, game.player_manager.current_player)

func economy_button_pressed():
	base_container.visible = false
	economy_container.visible = true

func military_button_pressed():
	ui_print("military_button_pressed")

func ui_tax_button_increased_pressed():
	var _success: bool = game.player_manager.current_player.tax_rate_change(true)
	update_tax_label()
	
func ui_tax_button_decreased_pressed():
	var _success: bool = game.player_manager.current_player.tax_rate_change(false)
	update_tax_label()
	
func update_tax_label():
	var val: int = game.player_manager.current_player.tax_rate
	var lbl: String = ""
	match val:
		0:
			lbl = "None"
		1:
			lbl = "Low"
		2:
			lbl = "Medium"
		3:
			lbl = "High"
	
	if tax_label.text != lbl:
		tax_label.text = lbl

# TODO - console/messaging
func ui_print(msg: String):
	print(msg)

func unload(menu):
	menu.visible = false

	# TODO - stack based menus
	ui.visible = true
