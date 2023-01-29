extends CharacterBody3D
class_name fh_unit
# nodes
@onready var selector: MeshInstance3D = $selector
@onready var agent: NavigationAgent3D = $NavigationAgent3d
@onready var game = get_node("/root/game")

var SPEED: float = .2
var MIN_DISTANCE: float = 1 # min distance to destinations before counted as being there
var WORK_TIME_MAX: float = 1 # currently 1 swing of an axe, resource entity tracks progress of getting resource amount

# state
var destination: Vector3
var destination_goal: fh_entity

var resources
var max_resources
var current_state: Enums.STATE = Enums.STATE.IDLE
var unit_type: Enums.UNIT_TYPE = Enums.UNIT_TYPE.CIVILIAN 
var entity_category: Enums.ENTITY_CATEGORY:
	get:
		match entity_type:
			Enums.ENTITY.NOT_SET:
				return Enums.ENTITY_CATEGORY.NOT_SET
			Enums.ENTITY.BUILDING_CASTLE:
				return Enums.ENTITY_CATEGORY.BUILDING
			Enums.ENTITY.BUILDING_WOODCHOPPER:
				return Enums.ENTITY_CATEGORY.BUILDING
			Enums.ENTITY.BUILDING_WAREHOUSE:
				return Enums.ENTITY_CATEGORY.BUILDING
			Enums.ENTITY.BUILDING_QUARRY:
				return Enums.ENTITY_CATEGORY.BUILDING
			Enums.ENTITY.UNIT_UNEMPLOYED:
				return Enums.ENTITY_CATEGORY.UNIT
			Enums.ENTITY.UNIT_WOODCHOPPER:
				return Enums.ENTITY_CATEGORY.UNIT
			Enums.ENTITY.UNIT_QUARRYWORKER:
				return Enums.ENTITY_CATEGORY.UNIT
			Enums.ENTITY.RESOURCE_TREE:
				return Enums.ENTITY_CATEGORY.RESOURCE
			Enums.ENTITY.RESOURCE_STONE:
				return Enums.ENTITY_CATEGORY.RESOURCE
		
		return Enums.ENTITY_CATEGORY.NOT_SET
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

	game.ui_manager.ui_print("get_unit_type: ent_type not in match statement")
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
				if is_near(game.entity_manager.get_entity_destination(player_owner.castle)):
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
					move_to(game.entity_manager.get_entity_destination(player_owner.castle))
					current_state = Enums.STATE.MOVING
				return
				
			if unit_type == Enums.UNIT_TYPE.CIVILIAN:
				# if they have a destination
				if destination_goal == null || destination_goal == player_owner.castle:
					# check for workplace or destination
					if workplace == null:
						entity_type = Enums.ENTITY.UNIT_UNEMPLOYED
					else:
						go_to_work_building()
				else:
					if is_near(destination):
						# going to work building
						if destination_goal == workplace:
							if has_resources():
								work_time = 0
								current_state = Enums.STATE.WORKING
							else:
								# get resource goal destination
								var goal: fh_entity = game.entity_manager.find_work_target(entity_type, self)
								if goal != null:
									destination_goal = goal
									move_to(game.entity_manager.get_entity_destination(destination_goal))
									current_state = Enums.STATE.MOVING
						# going to warehouse
						elif destination_goal.entity_type == Enums.ENTITY.BUILDING_WAREHOUSE:
							# drop off resources
							destination_goal.resources.add_resource(workplace_processed_resource_type, resources.get_resource_value(workplace_processed_resource_type))
							player_owner.resources.add_resource(workplace_processed_resource_type, resources.get_resource_value(workplace_processed_resource_type))
							resources.set_resource(workplace_processed_resource_type, 0)
							current_state = Enums.STATE.IDLE
							destination_goal = null
						# going to work target
						elif destination_goal.entity_type == game.entity_manager.get_work_target_type(entity_type):
							current_state = Enums.STATE.WORKING
					else:
						# not near destination, change state
						current_state = Enums.STATE.MOVING
			elif unit_type == Enums.UNIT_TYPE.MILITARY:
				return # TODO
		Enums.STATE.MOVING:
			moving_tick(delta)
		Enums.STATE.WORKING:
			if destination_goal == workplace:
				do_work(delta)
			else:
				collect_resource(delta)

func collect_resource(delta: float):
	if work_time == 0:
		# TODO play animation
		pass
	
	if work_time >= WORK_TIME_MAX:
		var res_val: int = destination_goal.action_performed()
		resources.add_resource(workplace_resource_type, res_val)
		
		if resources.get_resource_value(workplace_resource_type) >= max_resources.get_resource_value(workplace_resource_type):
			if workplace_resource_type == Enums.RESOURCE.STONE:
				go_to_warehouse()
			else:
				go_to_work_building()
			
		work_time = 0
	
	work_time += delta

# TODO - implement similar to collect resource, move tree logic to entity manager for action performed
func do_work(delta: float):
	if work_time == 0:
		# TODO play animation
		pass
	
	# work completed
	if work_time >= WORK_TIME_MAX:
		# minus old resource
		resources.set_resource(workplace_resource_type, 0)
		
		# add new resource
		resources.set_resource(workplace_processed_resource_type, max_resources.get_resource_value(workplace_processed_resource_type))
		# send them to warehouse
		var gone_warehouse: bool = go_to_warehouse()
		if !gone_warehouse:
			return
		
	
	work_time += delta

func go_to_warehouse() -> bool:
	var wh: fh_entity = null
	wh = game.entity_manager.find_entity(wh, Enums.ENTITY.BUILDING_WAREHOUSE)
	while (wh != null):
		if wh.player_owner == self.player_owner:
			if wh.resources.space_left(workplace_processed_resource_type) >= resources.get_resource_value(workplace_processed_resource_type):
				destination_goal = wh
				move_to(game.entity_manager.get_entity_destination(wh))
				current_state = Enums.STATE.MOVING
				break
		wh = game.entity_manager.find_entity(wh, Enums.ENTITY.BUILDING_WAREHOUSE)
		
	if wh == null:
		# not found, wait a bit before checking again
		print("No warehouse found!")
		work_time -= 1
		return false
		
	return true

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
			var next_location = agent.get_next_path_position()
			var v = global_transform.origin.direction_to(next_location).normalized() * SPEED
			agent.set_velocity(v)
			look_at(next_location)
		else:
			move_to(agent.get_final_position())
#			agent.set_velocity(Vector3.ZERO)
#			current_state = Enums.STATE.IDLE
	else:
		velocity.y -= gravity * delta
		move_and_slide()

func go_to_work_building():
	destination_goal = workplace
	move_to(game.entity_manager.get_entity_destination(destination_goal))
	current_state = Enums.STATE.MOVING

func move_to(dest: Vector3) -> void:
	destination = dest
	agent.set_target_position(destination)

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