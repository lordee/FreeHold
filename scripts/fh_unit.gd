extends CharacterBody3D
class_name fh_unit
# nodes
@onready var selector: MeshInstance3D = $selector
@onready var agent: NavigationAgent3D = $NavigationAgent3d
@onready var game = get_node("/root/game")

var SPEED: float = .2
var MIN_DISTANCE: float = 1 # min distance to destinations before counted as being there
var WORK_TIME_MAX: float = 5

# state
var destination: Vector3
var destination_goal: fh_entity

var resources
var max_resources
var current_state: Enums.STATE = Enums.STATE.IDLE
var unit_type: Enums.UNIT_TYPE = Enums.UNIT_TYPE.CIVILIAN 
var _entity_type: Enums.ENTITY = Enums.ENTITY.UNIT_UNEMPLOYED
var entity_type: Enums.ENTITY:
	get:
		return _entity_type
	set(value):
		var u_type: Enums.UNIT_TYPE = get_unit_type(value)
		unit_type = u_type
		workplace_resource_type = resources.get_entity_type_resource(value)
		workplace_processed_resource_type = resources.get_entity_type_processed_resource(value)
		max_resources = resources.get_max_resources(max_resources, value)
		if u_type == Enums.UNIT_TYPE.CIVILIAN:
			if value != Enums.ENTITY.UNIT_UNEMPLOYED:
				player_owner.work_population += 1
		_entity_type = value
var workplace
var workplace_resource_type: Enums.RESOURCE = Enums.RESOURCE.NOT_SET
var workplace_processed_resource_type: Enums.RESOURCE = Enums.RESOURCE.NOT_SET

var work_time: float = 0

var player_owner: fh_player = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_unit_type(ent_type: Enums.ENTITY):
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_UNEMPLOYED:
			return Enums.UNIT_TYPE.CIVILIAN

	assert(false, "get_unit_type: ent_type not in match statement")
	return Enums.UNIT_TYPE.CIVILIAN

func _ready():
	agent.velocity_computed.connect(on_velocity_computed)
	agent.path_changed.connect(on_path_changed)
	agent.target_reached.connect(on_target_reached)
	resources = fh_resources.new()
	max_resources = fh_resources.new()

func _physics_process(delta: float) -> void:
	match current_state:
		Enums.STATE.IDLE:
			if entity_type == Enums.ENTITY.UNIT_UNEMPLOYED:
				if is_near(player_owner.castle.gather_area.global_transform.origin):
					# search for employment
					var building = game.entity_manager.get_unoccupied_building(player_owner)
					if building == null:
						return
					
					var e_type: Enums.ENTITY = game.entity_manager.occupy_building(building, self)
					if e_type == Enums.ENTITY.NOT_SET:
						return
						
					entity_type = e_type
					workplace = building
					return
				else:
					move_to(player_owner.castle.gather_area.global_transform.origin)
					current_state = Enums.STATE.MOVING
				return
				
			if unit_type == Enums.UNIT_TYPE.CIVILIAN:
				if is_near(workplace.entry.global_transform.origin):
					# get resource or do work
					if has_resources():
						work_time = 0
						current_state = Enums.STATE.WORKING
					else:
						var goal: fh_entity = game.entity_manager.find_work_target(entity_type, self)
						if goal != null:
							destination_goal = goal
							move_to(goal.global_transform.origin)
							current_state = Enums.STATE.MOVING
				else:
					if workplace == null:
						entity_type = Enums.ENTITY.UNIT_UNEMPLOYED
					else:
						go_to_work_building()
						
			elif unit_type == Enums.UNIT_TYPE.MILITARY:
				return # TODO
		Enums.STATE.MOVING:
			moving_tick(delta)
		Enums.STATE.WORKING:
			do_work(delta)
		Enums.STATE.MOVING_TO_WAREHOUSE:
			if is_near(destination):
				# give resources to warehouse
				# go back to idle
				if destination_goal != null:
					destination_goal.resources.add_resource(workplace_processed_resource_type, resources.get_resource_value(workplace_processed_resource_type))
					resources.set_resource(workplace_processed_resource_type, 0)
					current_state = Enums.STATE.IDLE
				

func do_work(delta: float):
	if work_time == 0:
		# TODO play animation
		pass
	
	if work_time >= WORK_TIME_MAX:
		# work completed
		# minus old resource
		resources.set_resource(workplace_resource_type, 0)
		
		# add new resource
		resources.set_resource(workplace_processed_resource_type, max_resources.get_resource_value(workplace_processed_resource_type))
		# send them to warehouse
		var wh: fh_entity = null
		wh = game.entity_manager.find_entity(wh, Enums.ENTITY.BUILDING_WAREHOUSE)
		while (wh != null):
			if wh.player_owner == self.player_owner:
				if wh.resources.space_left(workplace_processed_resource_type) >= resources.get_resource_value(workplace_processed_resource_type):
					move_to(wh.global_transform.origin)
					current_state = Enums.STATE.MOVING_TO_WAREHOUSE
					destination_goal = wh
					break
			wh = game.entity_manager.find_entity(wh, Enums.ENTITY.BUILDING_WAREHOUSE)
			
		if wh == null:
			# not found, wait a bit before checking again
			work_time -= 1
		return
	
	work_time += delta

func has_resources() -> bool:
	if resources.get_resource_value(workplace_resource_type) > 0:
		return true
		
	return false

func is_near(org: Vector3) -> bool:
	var length = (org - global_transform.origin).length()
	
	if length <= MIN_DISTANCE:
		return true
	else:
		return false

func moving_tick(delta):
	if is_on_floor():
		if agent.is_target_reachable():
			var next_location = agent.get_next_location()
			var v = global_transform.origin.direction_to(next_location).normalized() * SPEED
			agent.set_velocity(v)
			look_at(next_location)
		else:
			agent.set_velocity(Vector3.ZERO)
			current_state = Enums.STATE.IDLE
	else:
		velocity.y -= gravity * delta
		move_and_slide()

func go_to_work_building():
	destination_goal = workplace
	move_to(workplace.entry.global_transform.origin)
	current_state = Enums.STATE.MOVING
	

func add_resource(resource_type: Enums.RESOURCE, val: int):
	resources.add_resource(resource_type, val)
	# TODO - carrying animation
	go_to_work_building()

func move_to(dest: Vector3) -> void:
	destination = dest
	agent.set_target_location(destination)

func select():
	selector.show()
	
func deselect():
	selector.hide()

func on_path_changed() -> void:
#	print("dest: " + str(destination))
#	print(agent.get_nav_path())
	pass

func on_velocity_computed(safe_velocity: Vector3) -> void:
	position += safe_velocity

func on_target_reached() -> void:
	current_state = Enums.STATE.IDLE
