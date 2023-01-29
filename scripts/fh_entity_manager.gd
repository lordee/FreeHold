extends Node

class_name fh_entity_manager

var entities: Array = Array()
var selected_entities: Array = Array()
@onready var game = get_node("/root/game")
var SCENES: Dictionary = {}
var entity_required_resources: Dictionary = {}

var building_being_placed: Node3D
var building_being_placed_valid: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SCENES[Enums.ENTITY.BUILDING_WOODCHOPPER] = ResourceLoader.load("res://scenes/buildings/woodchopper.tscn")
	SCENES[Enums.ENTITY.BUILDING_WAREHOUSE] = ResourceLoader.load("res://scenes/buildings/warehouse.tscn")
	SCENES[Enums.ENTITY.BUILDING_QUARRY] = ResourceLoader.load("res://scenes/buildings/quarry.tscn")
	SCENES[Enums.ENTITY.RESOURCE_TREE] = ResourceLoader.load("res://scenes/tree.tscn")
	SCENES[Enums.ENTITY.RESOURCE_STONE] = ResourceLoader.load("res://scenes/stone.tscn")
	SCENES[Enums.ENTITY.UNIT_UNEMPLOYED] = ResourceLoader.load("res://scenes/unit.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass

# fh_game calls this for each game tick, spawn animals etc
func process_entity_game_tick():
	for ent in entities:
		match ent.entity_type:
			Enums.ENTITY.RESOURCE_TREE:
				# chance for forest to grow
				if ent.life_stage == Enums.LIFE_STAGE.MATURE:
					# chance to sprout new tree within x distance
					ent.reproduce(false)
				else:
					ent.game_tick_age += 1

				# chance for animal to spawn
			

func find_entity(prev_ent: fh_entity, ent_type: Enums.ENTITY) -> fh_entity:
	var found: bool = false
	if prev_ent == null:
		found = true
	
	for ent in entities:
		if ent.entity_type == ent_type:
			if found:
				return ent
			else:
				if ent == prev_ent:
					found = true
				
	return null

func remove_entity(ent):
	entities.erase(ent)
	ent.queue_free()
	
func get_entity_required_resources(ent_type: Enums.ENTITY) -> fh_resources:
	if entity_required_resources.has(ent_type):
		return entity_required_resources[ent_type]
	else:
		var required_resources = fh_resources.new()
		match ent_type:
			Enums.ENTITY.BUILDING_WOODCHOPPER:
				required_resources.wooden_planks = 20
			Enums.ENTITY.BUILDING_WAREHOUSE:
				required_resources.wooden_planks = 100
			Enums.ENTITY.BUILDING_QUARRY:
				required_resources.wooden_planks = 150
		entity_required_resources[ent_type] = required_resources
		return required_resources

func get_entity_destination(entity: fh_entity) -> Vector3:
	match entity.entity_category:
		Enums.ENTITY_CATEGORY.NOT_SET:
			return Vector3.ZERO
		Enums.ENTITY_CATEGORY.UNIT:
			return entity.global_transform.origin
		Enums.ENTITY_CATEGORY.BUILDING:
			if entity.entity_type == Enums.ENTITY.BUILDING_CASTLE:
				return entity.gather_area.global_transform.origin
			else:
				return entity.entry.global_transform.origin
		Enums.ENTITY_CATEGORY.RESOURCE:
			return entity.global_transform.origin
			
	return Vector3.ZERO

func get_unoccupied_building(p_owner: fh_player) -> fh_entity:
	for ent in entities:
		if ent.player_owner == p_owner:
			if ent.entity_category == Enums.ENTITY_CATEGORY.BUILDING && !ent.occupied:
				return ent
	return null

func occupy_building(building: fh_entity, unit: fh_unit):
	if building.player_owner != unit.player_owner:
		return Enums.ENTITY.UNIT_UNEMPLOYED
		
	building.occupied = true
	return get_occupation(building.entity_type)
	
func get_occupation(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.BUILDING_WOODCHOPPER:
			return Enums.ENTITY.UNIT_WOODCHOPPER
		Enums.ENTITY.BUILDING_QUARRY:
			return Enums.ENTITY.UNIT_QUARRYWORKER
			
	return Enums.ENTITY.NOT_SET

func cancel_building_placement():
	if building_being_placed != null:
		building_being_placed.queue_free()
		building_being_placed = null
	game.input_manager.input_type = Enums.ENTITY_CATEGORY.NOT_SET

# TODO - rename func or move to fh_player
func player_has_resources_to_create_entity(player: fh_player, entity_type: Enums.ENTITY) -> bool:
	var resources_needed: fh_resources = get_entity_required_resources(entity_type)
	var have_resources: bool = false
	if (player.resources.flour >= resources_needed.flour 
	and player.resources.wooden_planks >= resources_needed.wooden_planks
	and player.resources.gold >= resources_needed.gold
	and player.resources.stone >= resources_needed.stone
	and player.resources.wood >= resources_needed.wood):
		have_resources = true
		
	return have_resources

func start_building_placement(building_type: Enums.ENTITY, p_owner: fh_player):
	cancel_building_placement()
	
	var scene: PackedScene = get_entity_scene(building_type)
	if scene == null:
		return
		
	# spawn scene
	var node = scene.instantiate()
	add_child(node)
	var area: Area3D = node.get_node("Area3D")
	node.entity_type = building_type
	
	area.body_entered.connect(self.building_area_entered.bind(area))
	area.body_exited.connect(self.building_area_exited.bind(area))

	validate_building_placement(area)
	building_being_placed = node
	building_being_placed.player_owner = p_owner
	game.input_manager.input_type = Enums.ENTITY_CATEGORY.BUILDING

func building_area_entered(body: Node3D, area: Area3D):
	if body.get_parent() == area.get_parent():
		return
		
	for node in area.get_parent().get_children():
		if node is MeshInstance3D:
			node.material_override = ResourceLoader.load("res://materials/red_transparent.tres")
			building_being_placed_valid = false

func validate_building_placement(area: Area3D):
	var overlapping_bodies = area.get_overlapping_bodies()
	var body_count: int = 0
	for body in overlapping_bodies:
		if body.get_parent() != area.get_parent():
			body_count += 1
		
	for node in area.get_parent().get_children():
		if node is MeshInstance3D:
			if body_count == 0:
				node.material_override = null
				building_being_placed_valid = true
			else:
				node.material_override = ResourceLoader.load("res://materials/red_transparent.tres")
				building_being_placed_valid = false

# somehow we can get less exits than enters, so instead of counting them, we will scan for overlaps on exit
func building_area_exited(_body: Node3D, area: Area3D):
	validate_building_placement(area)

func build() -> bool:
	if building_being_placed_valid == false:
		# TODO - sounds effects, message
		return false
		
	# check for resources required for building
	if (!player_has_resources_to_create_entity(building_being_placed.player_owner, building_being_placed.entity_type)):
		# TODO - play a sound
		game.ui_manager.ui_print("You do not have the resources for that")
		return false
		
	building_being_placed.player_owner.resources.merge_resource_objects(get_entity_required_resources(building_being_placed.entity_type), false)
		
	entities.append(building_being_placed)
	var area: Area3D = building_being_placed.get_node("Area3D")
	
	area.body_entered.disconnect(self.building_area_entered)
	area.body_exited.disconnect(self.building_area_exited)
	remove_child(building_being_placed)
	game.map_nav_region.add_child(building_being_placed)
	game.map_nav_region.bake_navigation_mesh()
	building_being_placed = null
	game.ui_manager.reset_ui_menus()
	return true

func populate_entities():
	for node in game.map_nav_region.get_children():
		if node is fh_entity:
			entities.append(node)
			move_to_floor(node)
			process_entity(node, true)
			
func spawn_peasant(player_owner: fh_player):
	var scene: PackedScene = get_entity_scene(Enums.ENTITY.UNIT_UNEMPLOYED)
	var unit: fh_unit = scene.instantiate()
	game.map_nav_region.add_child(unit)
	# TODO - constructors?
	player_owner.population += 1
	unit.player_owner = player_owner
	unit.global_transform.origin = player_owner.castle.entry.global_transform.origin
	unit.destination_goal = player_owner.castle
	unit.move_to(get_entity_destination(unit.destination_goal))
	move_to_floor(unit)
	game.map_nav_region.bake_navigation_mesh()
	entities.append(unit)
	
func get_entity_scene(entity_type: Enums.ENTITY) -> PackedScene:
	var scene: PackedScene = null
	scene = SCENES[entity_type]
	if scene == null:
#		var enum_name = Enums.ENTITY.keys()[building_type] 
		game.ui_manager.ui_print("scene not found in entity_manager get_entity_scene")
	
	return scene
	
func spawn_entity(entity_type: Enums.ENTITY, org: Vector3):
	var scene: PackedScene = get_entity_scene(entity_type)
	var node = scene.instantiate()
	game.map_nav_region.add_child(node)
	node.global_transform.origin = org
	game.map_nav_region.bake_navigation_mesh()

func get_work_target_type(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY.RESOURCE_TREE
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY.RESOURCE_STONE
			
	return Enums.ENTITY.NOT_SET

func find_work_target(e_type: Enums.ENTITY, worker: fh_unit) -> fh_entity:
	var targ: fh_entity = null
	var targ_type: Enums.ENTITY = get_work_target_type(e_type)

	var ent: fh_entity = find_entity(null, targ_type)
	if ent == null:
		return ent
	targ = ent
	var old_dist = (worker.global_transform.origin - targ.global_transform.origin).length()
	var new_dist
	while (ent != null):
		new_dist = (worker.global_transform.origin - ent.global_transform.origin).length()
		if new_dist < old_dist:
			targ = ent
			old_dist = new_dist
			
		ent = find_entity(ent, targ_type)
				
	return targ
	
func process_entity(ent: fh_entity, adding_entity: bool):
	var pop_add: int = 0
	var p_owner: fh_player = game.player_manager.get_player_owner()
	
	if ent.player_owner == null:
		ent.player_owner = p_owner
	
	if ent.player_owner != p_owner:
		return
	
	if ent.entity_type == Enums.ENTITY.BUILDING_CASTLE:
		pop_add += game.settings.castle_population
		p_owner.castle = ent
		p_owner.castle.occupied = true
	
	p_owner.add_population_max(pop_add, adding_entity)
	
func move_to_floor(object: Node3D):
	var ray_from: Vector3 = object.global_transform.origin
	var ray_to = ray_from + Vector3(0, -1, 0) * 1000
	var space_state: PhysicsDirectSpaceState3D = object.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	
	var results: Dictionary = space_state.intersect_ray(query)
	
	# FIXME - not completely accurate, do tests for is on floor or calc this better...
	if !results.is_empty():
		var position: Vector3 = results["position"]
#		position.y += object.scale.y
		object.global_transform.origin = position

func set_work_target(targ):
	for unit in selected_entities:
		unit.work_target = targ

func select_object(object):
	if object is fh_unit:
		if object.entity_type == Enums.ENTITY.UNIT_UNEMPLOYED:
			return

	var selector: MeshInstance3D = object.get_node_or_null("selector")
	if selector == null:
		return
		
	selector.show()
	selected_entities.append(object)
	
func deselect_all():
	for ent in selected_entities:
		var selector: MeshInstance3D = ent.get_node_or_null("selector")
		if selector == null:
			return
			
		selector.hide()
	selected_entities.clear()

func move_selected_units(dest_position: Vector3):
	for ent in selected_entities:
		ent.move_to(dest_position)