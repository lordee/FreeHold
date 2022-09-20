extends Node3D

var entity_manager: EntityManager
# Called when the node enters the scene tree for the first time.
func _ready():
	entity_manager = get_node("entity_manager")


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
	var map = map_scene.instantiate()
	add_child(map)
