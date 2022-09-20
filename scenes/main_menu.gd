extends Control

var start_button: Button
var game: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/game")
	start_button = get_node("VBoxContainer/start")
	start_button.pressed.connect(start_button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_button_pressed():
	game.start_game()
	visible = false
