extends Node

var BoundAction = load("res://BoundAction.gd")
var InputCommand = load("res://scripts/InputCommand.gd")

var camera_controller = null

var _bindings: Dictionary = {}
var _key_types: Dictionary = {}
var current_frame_cmd: InputCommand = InputCommand.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_controller = get_node("camera_controller")
	_key_types = populate_key_types() # FIXME figure out constants in gdscript and if we can apply to dicts
	bind("camera_zoom_in", "mwheelup", "camera_zoom_in")
	bind("camera_zoom_out", "mwheeldown", "camera_zoom_out");
	bind("camera_rotate", "mousethree", "camera_rotate");
	bind("camera_pan", "e", "camera_pan");
	bind("camera_forward", "w", "camera_forward");
	bind("camera_backward", "s", "camera_backward");
	bind("camera_right", "d", "camera_right");
	bind("camera_left", "a", "camera_left");
	bind("click_left", "mouseone", "click_left");
	bind("click_right", "mousetwo", "click_right");
	bind("building_rotate", "r", "building_rotate");
	
func _input(_event):
	for key in _bindings:
		var bind_info: BoundAction = _bindings[key]
		if bind_info.key_type.button_type == Enums.BUTTON_TYPE.MOUSEBUTTON:
			if Input.is_action_just_pressed(bind_info.action_name):
				bind_info.func_callable.call(1)
			if Input.is_action_just_released(bind_info.action_name):
				bind_info.func_callable.call(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for key in _bindings:
		var bind_info: BoundAction = _bindings[key]
		if bind_info.key_type.button_type == Enums.BUTTON_TYPE.SCANCODE:
			if Input.is_action_just_pressed(bind_info.action_name):
				bind_info.func_callable.call(1)
			if Input.is_action_just_released(bind_info.action_name):
				bind_info.func_callable.call(-1)
	
	# FIXME - prefer to store cmd list here and process/call methods from here
	#var test_cmd = current_frame_cmd.duplicate()
	# FIXME - gdscript doesn't have any clone options for objects...? If so, should make constructor accept same obj as an arg
	var c: InputCommand = InputCommand.new()
	c.zoom_direction = current_frame_cmd.zoom_direction
	c.is_panning = current_frame_cmd.is_panning
	c.is_rotating = current_frame_cmd.is_rotating
	c.building_rotate = current_frame_cmd.building_rotate
	c.click_left = current_frame_cmd.click_left
	c.click_right = current_frame_cmd.click_right
	c.move_forward = current_frame_cmd.move_forward
	c.move_left = current_frame_cmd.move_left
	
	
	camera_controller._input_commands.append(c)
	
	current_frame_cmd.zoom_direction = 0
	current_frame_cmd.is_panning = 0
	current_frame_cmd.is_rotating = 0
	current_frame_cmd.building_rotate = 0
	if current_frame_cmd.click_left == -1:
		current_frame_cmd.click_left = 0
	if current_frame_cmd.click_right == -1:
		current_frame_cmd.click_right = 0

func bind(action_name: String, key_name: String, func_callable: String):
	action_name = action_name.to_lower()
	key_name = key_name.to_lower()
	var callable: Callable = Callable(self, func_callable)
	var bound_action: BoundAction = BoundAction.new(action_name, key_name, callable)
	
	var key_type: KeyType = null
	var scan_code: int = 0
	if _key_types.has(key_name):
		bound_action.key_type = _key_types[key_name]
	else:
		scan_code = OS.find_keycode_from_string(key_name)
		if scan_code != 0:
			bound_action.key_type = KeyType.new(Enums.BUTTON_TYPE.SCANCODE, scan_code)
		else:
			print("Bind of key " + key_name + " is not valid")
			return
	
	if !InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	
	match bound_action.key_type.button_type:
		Enums.BUTTON_TYPE.SCANCODE:
			var event: InputEventKey = InputEventKey.new()
			event.keycode = bound_action.key_type.button_value
			InputMap.action_add_event(action_name, event)
		Enums.BUTTON_TYPE.MOUSEBUTTON:
			var event: InputEventMouseButton = InputEventMouseButton.new()
			event.button_index = bound_action.key_type.button_value
			InputMap.action_add_event(action_name, event)
		Enums.BUTTON_TYPE.MOUSEWHEEL:
			var event: InputEventMouseButton = InputEventMouseButton.new()
			event.button_index = bound_action.key_type.button_value
			InputMap.action_add_event(action_name, event)
	
	_bindings[key_name] = bound_action
	
	

func camera_zoom_in(_val: float):
	current_frame_cmd.zoom_direction = -1
	
func camera_zoom_out(_val: float):
	current_frame_cmd.zoom_direction = 1
	
func camera_rotate(val: float):
	current_frame_cmd.is_rotating = val
	
func camera_pan(val: float):
	current_frame_cmd.is_panning = val
	
func camera_forward(val: float):
	if val == 1:
		current_frame_cmd.move_forward = 1
	else:
		current_frame_cmd.move_forward = 0
		
func camera_backward(val: float):
	if val == 1:
		current_frame_cmd.move_forward = -1
	else:
		current_frame_cmd.move_forward = 0
		
func camera_right(val: float):
	if val == 1:
		current_frame_cmd.move_left = -1
	else:
		current_frame_cmd.move_left = 0

func camera_left(val: float):
	if val == 1:
		current_frame_cmd.move_left = 1
	else:
		current_frame_cmd.move_left = 0
		
func click_left(val: float):
	current_frame_cmd.click_left = val
	
func click_right(val: float):
	current_frame_cmd.click_right = val

func building_rotate(_val: float):
	current_frame_cmd.building_rotate = 1

func populate_key_types():
	var key_types: Dictionary = {}
	key_types["mouseone"] = KeyType.new(Enums.BUTTON_TYPE.MOUSEBUTTON, MOUSE_BUTTON_LEFT)
	key_types["mousetwo"] = KeyType.new(Enums.BUTTON_TYPE.MOUSEBUTTON, MOUSE_BUTTON_RIGHT)
	key_types["mousethree"] = KeyType.new(Enums.BUTTON_TYPE.MOUSEBUTTON, MOUSE_BUTTON_MIDDLE)
	key_types["mwheelup"] = KeyType.new(Enums.BUTTON_TYPE.MOUSEBUTTON, MOUSE_BUTTON_WHEEL_UP)
	key_types["mwheeldown"] = KeyType.new(Enums.BUTTON_TYPE.MOUSEBUTTON, MOUSE_BUTTON_WHEEL_DOWN)
	
	return key_types
