extends Node
class_name fh_ui_manager

var main_menu
var ui
var base_container: GridContainer
var economy_container: GridContainer
var military_container: GridContainer
var game



func _ready():
	game = get_node("/root/game")
	main_menu = $main_menu
	ui = $ui
	base_container = ui.get_node("CenterContainer/UIBaseContainer")
	base_container.get_node("economy").pressed.connect(economy_button_pressed)
	base_container.get_node("military").pressed.connect(military_button_pressed)
	economy_container = ui.get_node("CenterContainer/EconomyContainer")
	economy_container.get_node("woodchopper").pressed.connect(woodchopper_button_pressed)
	economy_container.get_node("cancel").pressed.connect(ui_cancel_button_pressed)
#	military_container = ui.get_node("CenterContainer/MilitaryContainer")

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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

func economy_button_pressed():
	base_container.visible = false
	economy_container.visible = true

func military_button_pressed():
	print("military_button_pressed")

func woodchopper_button_pressed():
	game.entity_manager.start_building_placement(Enums.BUILDING.WOODCHOPPER)

func unload(menu):
	menu.visible = false

	# TODO - stack based menus
	ui.visible = true
