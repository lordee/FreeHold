extends Node

class_name EntityManager

var entities: Array = Array()
var selected_entities: Array = Array()
var game

var scene_woodchopper: PackedScene

var building_being_placed: Node3D
var building_being_placed_valid: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/game")
	scene_woodchopper = ResourceLoader.load("res://scenes/buildings/woodchopper.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func cancel_building_placement():
	if building_being_placed != null:
		building_being_placed.queue_free()
		building_being_placed = null
	game.input_manager.input_type = Enums.INPUT_TYPE.NO_SELECTION
	
func start_building_placement(building_type):
	cancel_building_placement()
	var scene: PackedScene = null
	match building_type:
		Enums.BUILDING.WOODCHOPPER:
			scene = scene_woodchopper
			
	if scene == null:
		print("scene not found in entity_manager start_building_placement")
		return
		
	# spawn scene
	var node = scene.instantiate()
	add_child(node)
	var area: Area3D = node.get_node("Area3d")
	
	area.body_entered.connect(self.building_area_entered.bind(area))
	area.body_exited.connect(self.building_area_exited.bind(area))

	validate_building_placement(area)
	building_being_placed = node
	game.input_manager.input_type = Enums.INPUT_TYPE.BUILDING

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
	
#	for node in area.get_parent().get_children():
#		if node is MeshInstance3D:
#			if len(overlapping_bodies) == 0:
#				node.material_override = null
#			else:
#				var mat = node.mesh.surface_get_material(0)
#				var array = node.mesh.surface_get_arrays(0)
#				node.mesh = ArrayMesh.new()
#				node.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, array)
#				node.mesh.surface_set_material(0, mat)

# somehow we can get less exits than enters, so instead of counting them, we will scan for overlaps on exit
func building_area_exited(body: Node3D, area: Area3D):
	validate_building_placement(area)

func build() -> bool:
	if building_being_placed_valid == false:
		# TODO - sounds effects, message
		return false
		
	entities.append(building_being_placed)
	var area: Area3D = building_being_placed.get_node("Area3d")
	
	area.body_entered.disconnect(self.building_area_entered)
	area.body_exited.disconnect(self.building_area_exited)
	remove_child(building_being_placed)
	game.map_nav_region.add_child(building_being_placed)
	game.map_nav_region.bake_navigation_mesh()
	building_being_placed = null
	game.ui_manager.reset_ui_menus()
	return true

func populate_entities():
	# for testing
	var u: Unit = get_node_or_null("/root/game/map/unit")
	if u != null:
		entities.append(u)
		move_to_floor(u)
		
func move_to_floor(object: Node3D):
	var ray_from: Vector3 = object.global_transform.origin
	var ray_to = ray_from + Vector3(0, -1, 0) * 1000
	var space_state: PhysicsDirectSpaceState3D = object.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	
	var results: Dictionary = space_state.intersect_ray(query)
	
	# FIXME - not completely accurate, do tests for is on floor or calc this better...
	if !results.is_empty():
		var position: Vector3 = results["position"]
		position.y += object.scale.y
		object.global_transform.origin = position

func set_work_target(targ):
	for unit in selected_entities:
		unit.work_target = targ

func select_object(object):
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
