extends Node3D

var InputCommand = load("res://scripts/InputCommand.gd")

# nodes
var elevation: Node3D
var camera: Camera3D
var selection_box: Control
var input_manager
var entity_manager: EntityManager
var game
var ui_manager

# settings
var _movement_speed: float = 20
var _rotation_speed: float = 20
var _inverted_y: bool = false
var _elevation_angle_max: float = 1 #80
var _elevation_angle_min: float = 0.07 #10
var _zoom_speed: float = 20
var _zoom_speed_damp: float = 0.8
var _zoom_minimum: float = 3
var _zoom_maximum: float = 40
var _ray_length: int = 1000
var _zoom_to_cursor: bool = false
var _pan_speed: float = 2

# state
var _lock_movement: bool
var _input_commands: Array
var _zoom_direction: float
var _is_rotating: bool
var _last_mouse_position: Vector2
var _is_panning: bool
var _move_forward: float
var _move_left: float
var _click_left: float
var _is_holding_click_left: bool
var _start_select_position: Vector2
var _click_right: float
var _is_holding_click_right: bool
var _building_rotate: float

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("elevation/Camera3d")
	elevation = get_node("elevation")
	selection_box = get_node("selection_box")
	input_manager = get_parent()
	game = get_node("/root/game")
	entity_manager = game.get_node("entity_manager")
	ui_manager = game.get_node("ui_manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _lock_movement == true:
		return
		
	var cmd: InputCommand = InputCommand.new()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	if !_input_commands.is_empty():
		cmd = _input_commands[0]
		_zoom_direction = cmd.zoom_direction if cmd.zoom_direction != 0 else _zoom_direction
		
		if cmd.is_rotating == 1:
			_is_rotating = true
			_last_mouse_position = get_viewport().get_mouse_position()
		elif cmd.is_rotating == -1:
			_is_rotating = false
			
		if cmd.is_panning == 1:
			_is_panning = true
			_last_mouse_position = get_viewport().get_mouse_position()
		elif cmd.is_panning == -1:
			_is_panning = false
			
		_move_forward = cmd.move_forward
		_move_left = cmd.move_left
		
		if cmd.click_left == 1:
			if _click_left == 1:
				_is_holding_click_left = true
			else:
				_start_select_position = mouse_pos
		else:
			_is_holding_click_left = false
		_click_left = cmd.click_left
		
		if cmd.click_right == 1 && _click_right == 1:
			_is_holding_click_right = true
		else:
			_is_holding_click_right = false
		_click_right = cmd.click_right
		
		_building_rotate = cmd.building_rotate
		
		move(delta)
		rotate_and_elevate(delta)
		zoom(delta)
		pan(delta)
		
		if _click_left == 1 && !_is_holding_click_left: # first click
			selection_box.start_pos = mouse_pos
			
		if _is_holding_click_left:
			selection_box.mouse_pos = mouse_pos
			selection_box.draw_box = true
		else:
			selection_box.draw_box = false
		
		match input_manager.input_type:
			Enums.INPUT_TYPE.UNIT:
				pass
			Enums.INPUT_TYPE.NO_SELECTION:
				process_clicks(mouse_pos)
			Enums.INPUT_TYPE.BUILDING:
				process_building_input(mouse_pos)
#					private void InputPlacingBuilding(Vector2 mPos)
#	{
#		if (_buildingRotate == 1)
#		{
#			Game.BuildingManager.PlacingBuilding.RotateY(90);
#		}
#
#		if (_clickRight == 1)
#		{
#			// cancel placement
#			ClickState = ClickState.NoSelection;
#			Game.BuildingManager.CancelBuildingPlacement();
#		}
#		else if (_clickLeft == 1)
#		{
#			ClickState = ClickState.NoSelection;
#			Game.BuildingManager.Build();
#		}
#	}
		
		if _click_left == -1:
			_click_left = 0

		_input_commands.clear()
			
func move(delta):
	var velocity: Vector3 = get_desired_velocity() * delta * _movement_speed
	self.position += velocity

func process_building_input(mouse_pos):
	var results: Dictionary = raycast_from_mouse()
	
	if !results.is_empty():
		var position: Vector3 = results["position"]
		position.y = game.floor.global_transform.origin.y * game.floor.scale.y
#		position.y += game.entity_manager.building_being_placed.position.y * game.entity_manager.building_being_placed.scale
		entity_manager.building_being_placed.global_transform.origin = position
		
	if _building_rotate == 1:
		entity_manager.building_being_placed.rotate_y(90)
		
	if _click_right == 1:
		# cancel placement
		entity_manager.cancel_building_placement()
		input_manager.input_type = Enums.INPUT_TYPE.NO_SELECTION
	elif _click_left == 1:
		var build_result = entity_manager.build()
		if build_result:
			input_manager.input_type = Enums.INPUT_TYPE.NO_SELECTION

func process_clicks(mouse_pos: Vector2):
	if _click_right == -1: # set on release
		move_selected_units()
		

		
	if _click_left == -1: # just released
		select_objects(mouse_pos)

func move_selected_units():
	var results: Dictionary = raycast_from_mouse()
	print(results)
	if !results.is_empty():
		if results["collider"].is_in_group("fh_tree"):
			var tree = results["collider"].get_parent().get_parent()
			entity_manager.set_work_target(tree)
		else:
			entity_manager.move_selected_units(results["position"])

func select_objects(mouse_pos: Vector2):
	entity_manager.deselect_all()
	
	if mouse_pos.distance_squared_to(_start_select_position) < 16:
		var results: Dictionary = raycast_from_mouse()
		if !results.is_empty():
			if results["collider"] is Unit:
				entity_manager.select_object(results["collider"])
			
	else:
		select_objects_in_select_box(selection_box.start_pos, selection_box.mouse_pos)
			

func select_objects_in_select_box(top_left: Vector2, bot_right: Vector2):
	if top_left.x > bot_right.x:
		var tmp = top_left.x
		top_left.x = bot_right.x
		bot_right.x = tmp
	if top_left.y > bot_right.y:
		var tmp = top_left.y
		top_left.y = bot_right.y
		bot_right.y = tmp
		
	var box: Rect2 = Rect2(top_left, bot_right - top_left)
	
	for entity in entity_manager.entities:
		if box.has_point(camera.unproject_position(entity.global_transform.origin)):
			entity_manager.select_object(entity)
	


func get_desired_velocity():
	var vel: Vector3 = Vector3.ZERO
	
	if _is_panning:
		return vel
		
	if _move_forward == 1:
		vel -= self.transform.basis.z
	elif _move_forward == -1:
		vel += self.transform.basis.z
		
	if _move_left == 1:
		vel -= self.transform.basis.x
	elif _move_left == -1:
		vel += self.transform.basis.x
		
	return vel.normalized()
	
func rotate_and_elevate(delta):
	if !_is_rotating:
		return
		
	var mouse_speed: Vector2 = get_mouse_speed()
	
	# rotate
	var rot: Vector3 = self.rotation
	rot.y += _rotation_speed * mouse_speed.x * delta
	self.rotation = rot
	
	elevate(mouse_speed.y, delta)
	
func get_mouse_speed():
	var current_pos: Vector2 = get_viewport().get_mouse_position()
	var mouse_speed: Vector2 = current_pos - _last_mouse_position
	_last_mouse_position = current_pos
	
	return mouse_speed

func elevate(amount: float, delta: float):
	var new_elevation: float = elevation.rotation.x
	
	if _inverted_y:
		new_elevation += _rotation_speed * amount * delta
	else:
		new_elevation -= _rotation_speed * amount * delta
	
	var rot: Vector3 = elevation.rotation
	rot.x = clampf(new_elevation, -_elevation_angle_max, -_elevation_angle_min)
	elevation.rotation = rot

func zoom(delta: float):
	if _zoom_direction == 0:
		return
	var new_zoom: float = clampf(camera.position.z + _zoom_direction * _zoom_speed * delta, _zoom_minimum, _zoom_maximum)
	var results: Dictionary = raycast_from_mouse()
	var trans: Vector3 = camera.position
	trans.z = new_zoom;
	camera.position = trans
	
	if !results.is_empty():
		var pointing_at: Vector3 = results["position"]
		if _zoom_to_cursor:
			realign_camera(pointing_at)
	
	_zoom_direction *= _zoom_speed_damp
	if absf(_zoom_direction) < 0.0001:
		_zoom_direction = 0

func raycast_from_mouse() -> Dictionary:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_from: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_to: Vector3 = ray_from + camera.project_ray_normal(mouse_pos) * _ray_length
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	return space_state.intersect_ray(query)

func realign_camera(point: Vector3):
	var dict: Dictionary = raycast_from_mouse()
	if !dict.is_empty():
		position += (point - dict["position"])
		
func pan(delta: float):
	if !_is_panning:
		return
		
	var mouse_speed: Vector2 = get_mouse_speed()
	var velocity: Vector3 = (global_transform.basis.z * mouse_speed.y + global_transform.basis.x * mouse_speed.x) * delta * _pan_speed
	position -= velocity
