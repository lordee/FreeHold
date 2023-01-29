extends Node3D

class_name fh_game

@onready var entity_manager: fh_entity_manager = get_node("entity_manager")
@onready var player_manager: fh_player_manager = get_node("player_manager")
@onready var input_manager: fh_input_manager = get_node("input_manager")
@onready var ui_manager: fh_ui_manager = get_node("ui_manager")
var map_floor: MeshInstance3D
var map_nav_region: NavigationRegion3D
var settings: game_settings = game_settings.new()

var game_started: bool = false
var game_tick: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	if game_started == false:
		return
	
	game_tick += delta
	
	for player in player_manager.get_children():
		# happiness/peasant spawning
		player.last_spawn_time += delta
		
		# calc happiness
		player.happiness = settings.default_happiness - player.population
		var pop_diff = player.population_max - player.population
		
		# check if we spawn another peasant
		var time_to_spawn: float = 10 - (player.happiness / 10)
		if time_to_spawn <= settings.spawn_time_min:
			time_to_spawn = settings.spawn_time_min
		if time_to_spawn <= player.last_spawn_time:
			if pop_diff >= 1:
				entity_manager.spawn_peasant(player)
				player.last_spawn_time = 0
				
		
		if game_tick >= settings.game_tick_period:
			game_tick = 0
			# pay taxes
			player.resources.add_resource(Enums.RESOURCE.GOLD, player.get_tax_income())
			
			# spawn animals, grow food, trees etc
			entity_manager.process_entity_game_tick()

func start_game():
	game_started = true
	player_manager.add_player("1")
	ui_manager.setup_ui()
	load_map()
	entity_manager.populate_entities()
	

func load_map():
	var map_scene: PackedScene = ResourceLoader.load("res://scenes/map_test.tscn")
	var map = map_scene.instantiate()
	map_nav_region = map.get_node("NavigationRegion3d")
	map_floor = map.find_child("Floor")
	add_child(map)
	
	
