extends Control

var start_button: Button
var game: Node3D
var ui_manager: fh_ui_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/game")
	ui_manager = game.get_node("ui_manager")
	start_button = get_node("VBoxContainer/start")
	start_button.pressed.connect(start_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_button_pressed():
	game.start_game()
	ui_manager.unload(self)
