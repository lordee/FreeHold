extends Node

class_name fh_player_manager

var current_player: fh_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_player_owner() -> fh_player:
	return current_player

func add_player(node_name: String):
	var node_scene: PackedScene = ResourceLoader.load("res://scenes/fh_player.tscn")
	var node = node_scene.instantiate()
	node.name = node_name
	add_child(node)
	
	current_player = node
