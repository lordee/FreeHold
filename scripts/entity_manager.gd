extends Node

class_name EntityManager

var entities: Array = Array()
var selected_entities: Array = Array()
var game

var scene_woodchopper: PackedScene

var building_being_placed

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/game")
	scene_woodchopper = ResourceLoader.load("res://scenes/woodchopper.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func cancel_building_placement():
	building_being_placed.queue_free()
	
func start_building_placement(building_type):
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
	building_being_placed = node
	game.input_manager.input_type = Enums.INPUT_TYPE.BUILDING
		
func build() -> bool:
	entities.append(building_being_placed)
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
		ent.work_target = null
		ent.move_to(dest_position)
