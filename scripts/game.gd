extends Node3D

var entity_manager: EntityManager
var input_manager
var ui_manager: fh_ui_manager
var map
var map_floor: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	entity_manager = get_node("entity_manager")
	input_manager = get_node("input_manager")
	ui_manager = get_node("ui_manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_game():
	print("game started")
	load_map()
	entity_manager.populate_entities()
	#add_player()

func load_map():
	var map_scene: PackedScene = ResourceLoader.load("res://scenes/map_test.tscn")
	map = map_scene.instantiate()
	map_floor = map.find_child("Floor")
	add_child(map)
	
	
