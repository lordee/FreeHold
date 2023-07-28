extends CharacterBody3D
class_name fh_unit
# nodes
@onready var model: Node3D = $model
@onready var selector: MeshInstance3D = $model/selector
@onready var agent: NavigationAgent3D = $NavigationAgent3d
@onready var game: fh_game = get_node("/root/game")

var SPEED: float = .2
var MIN_DISTANCE: float = 1.5 # min distance to destinations before counted as being there
var WORK_TIME_MAX: float = 1 # currently 1 swing of an axe, resource entity tracks progress of getting resource amount

# state
var destination: Vector3
var destination_goal: fh_entity

var resources: fh_resources
var current_state: Enums.STATE = Enums.STATE.IDLE
var collecting_resources: bool = false #dirty hack
var unit_type: Enums.UNIT_TYPE = Enums.UNIT_TYPE.CIVILIAN 
var entity_category: Enums.ENTITY_CATEGORY:
	get:
		return game.data.items[entity_type].entity_category

var _entity_type: Enums.ENTITY = Enums.ENTITY.UNIT_UNEMPLOYED
var entity_type: Enums.ENTITY:
	get:
		return _entity_type
	set(value):
		var data_item: fh_data_item = game.data.items[value]
		unit_type = data_item.unit_type
		workplace_resource_type = data_item.resource_level_one
		workplace_processed_resource_type = data_item.resource_level_two

		if data_item.unit_type == Enums.UNIT_TYPE.CIVILIAN:
			if value != Enums.ENTITY.UNIT_UNEMPLOYED:
				player_owner.work_population += 1
		_entity_type = value
var workplace
var workplace_resource_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
var workplace_processed_resource_type: Enums.ENTITY = Enums.ENTITY.NOT_SET

var work_time: float = 0

var player_owner: fh_player = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	agent.velocity_computed.connect(on_velocity_computed)
	agent.path_changed.connect(on_path_changed)
	agent.target_reached.connect(on_target_reached)
	resources = fh_resources.new()

func _physics_process(delta: float) -> void:
	match current_state:
		Enums.STATE.IDLE:
			if entity_type == Enums.ENTITY.UNIT_UNEMPLOYED:
				unemployed_idle()
				return
				
			if unit_type == Enums.UNIT_TYPE.CIVILIAN:
				civilian_idle()
			elif unit_type == Enums.UNIT_TYPE.MILITARY:
				military_idle()
		Enums.STATE.MOVING:
			moving_tick(delta)
		Enums.STATE.WORKING:
			if destination_goal == workplace:
				do_work(delta)
			else:
				collect_resource(delta)

func unemployed_idle():
	if is_near(game.entity_manager.get_entity_destination(player_owner.castle)):
		# search for military work first
		var mil_type: Enums.ENTITY = game.entity_manager.build_unit(player_owner, self.name)
		if mil_type != Enums.ENTITY.NOT_SET:
			self.entity_type = mil_type
			return
		
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
		
func military_idle():
	# if no resources, unit is reserved, head to barracks
	if !self.has_resources():
		collecting_resources = true
		# if near barracks, get resources
		if destination_goal.entity_type == Enums.ENTITY.BUILDING_BARRACKS:
			if is_near(destination):
				# collect resources
				at_destination_drop_or_collect()
			else: #
				go_to_barracks()
				return
		else: # go to barracks
			go_to_barracks()
			return
	
	# FIXME check for targets in range
	
func refresh_model():
	if collecting_resources == false:
		var model_scene: PackedScene = game.data.items[entity_type].scene
		game.entity_manager.set_model(self, model_scene)
	

func go_to_barracks():
	# TODO - limit barracks to 1 building allowed
	var goal: fh_entity = null
	goal = game.entity_manager.find_entity(goal, Enums.ENTITY.BUILDING_BARRACKS)
	while goal != null:
		if goal.player_owner == self.player_owner:
			destination_goal = goal
			move_to(game.entity_manager.get_entity_destination(destination_goal))
			self.current_state = Enums.STATE.MOVING
			break
		else:
			goal = game.entity_manager.find_entity(goal, Enums.ENTITY.BUILDING_BARRACKS)
	
func civilian_idle():
	# if they don't have a destination or are heading to the castle
	if destination_goal == null || destination_goal == player_owner.castle:
		# check for workplace or go unemployed
		if workplace == null:
			entity_type = Enums.ENTITY.UNIT_UNEMPLOYED
		else:
			# TODO - allow to go back to work collecting rather than back to workplace - 
			# for instance flour drop off is an extra trip back to workplace to then return to warehouse for more wheat
			go_to_work_building()
			collecting_resources = false
	else: # they are heading somewhere
		if is_near(destination):
			# if going to work building
			if destination_goal == workplace:
				# resources + workplace = working
				if has_resources():
					work_time = 0
					current_state = Enums.STATE.WORKING
				else: # needs to get resources
					# get resource goal destination
					var goal: fh_entity = game.entity_manager.find_work_target(entity_type, self)
					if goal != null:
						destination_goal = goal
						move_to(game.entity_manager.get_entity_destination(destination_goal))
						current_state = Enums.STATE.MOVING
						if destination_goal.entity_type == Enums.ENTITY.BUILDING_WAREHOUSE:
							collecting_resources = true
			# going to warehouse
			elif destination_goal.entity_type == Enums.ENTITY.BUILDING_WAREHOUSE:
				at_destination_drop_or_collect()
			# going to armoury
			elif destination_goal.entity_type == Enums.ENTITY.BUILDING_ARMOURY:
				at_destination_drop_or_collect()
			# going to work target
			elif destination_goal.entity_type == game.data.items[entity_type].resource_level_one:
				current_state = Enums.STATE.WORKING
		else:
			# not near destination, change state
			current_state = Enums.STATE.MOVING

func civilian_collect():
	# get the resources we reserved + extra if needed
	var req_amount: int = game.data.items[self.entity_type].resource_level_one_max_carry
	req_amount = req_amount - self.resources.get_resource_value(game.data.items[self.entity_type].resource_level_one)
	destination_goal.resources.collect_resource(self, workplace_resource_type, req_amount)
	player_owner.resources.collect_resource(self, workplace_resource_type, req_amount)
	collecting_resources = false

func military_collect():
	for key in game.data.items[entity_type].required_resources:
		var value_req = game.data.items[entity_type].required_resources[key]
		if self.resources.get_resource_value(key, true) < value_req:
			destination_goal.resources.collect_resource(self, key, value_req)
			player_owner.resources.collect_resource(self, key, value_req)
			
			# change mesh
			collecting_resources = false
			refresh_model()

func at_destination_drop_or_collect():
	if collecting_resources == true:
		if self.unit_type == Enums.UNIT_TYPE.CIVILIAN:
			civilian_collect()
			# return to work
			go_to_work_building()
		elif self.unit_type == Enums.UNIT_TYPE.MILITARY:
			military_collect()
	else:
		# drop off resources
		destination_goal.resources.add_resource(workplace_processed_resource_type, resources.get_resource_value(workplace_processed_resource_type))
		player_owner.resources.add_resource(workplace_processed_resource_type, resources.get_resource_value(workplace_processed_resource_type))
		resources.set_resource(workplace_processed_resource_type, 0)
		current_state = Enums.STATE.IDLE
		destination_goal = null


func collect_resource(delta: float):
	if work_time == 0:
		# TODO play animation
		pass
	
	if work_time >= WORK_TIME_MAX:
		var res_val: int = destination_goal.action_performed()
		resources.add_resource(workplace_resource_type, res_val)
		
		if resources.get_resource_value(workplace_resource_type) >= game.data.items[entity_type].resource_level_one_max_carry:
			match game.data.items[entity_type].resource_level_one_dropoff_point:
				Enums.RESOURCE_PROCESS_POINT.WAREHOUSE:
					go_to_resource_drop(Enums.ENTITY.BUILDING_WAREHOUSE)
				Enums.RESOURCE_PROCESS_POINT.ARMOURY:
					go_to_resource_drop(Enums.ENTITY.BUILDING_ARMOURY)
				Enums.RESOURCE_PROCESS_POINT.WORKPLACE:
					go_to_work_building()
				Enums.RESOURCE_PROCESS_POINT.NOT_SET:
					game.ui_manager.ui_print("collect_resource resource process point not set")
			
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
		resources.set_resource(workplace_processed_resource_type, game.data.items[entity_type].resource_level_two_max_carry)
		# send them to warehouse
		var e_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
		match game.data.items[entity_type].resource_level_two_dropoff_point:
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE:
				e_type = Enums.ENTITY.BUILDING_WAREHOUSE
			Enums.RESOURCE_PROCESS_POINT.ARMOURY:
				e_type = Enums.ENTITY.BUILDING_ARMOURY
			Enums.RESOURCE_PROCESS_POINT.NOT_SET:
				game.ui_manager.ui_print("do_work resource process point not set")
		var gone: bool = go_to_resource_drop(e_type)
		if !gone:
			return
	
	work_time += delta

func go_to_resource_drop(e_type: Enums.ENTITY) -> bool:
	var wh: fh_entity = null
	wh = game.entity_manager.find_entity(wh, e_type)
	while (wh != null):
		if wh.player_owner == self.player_owner:
			if wh.resources.space_left(workplace_processed_resource_type) >= resources.get_resource_value(workplace_processed_resource_type):
				destination_goal = wh
				move_to(game.entity_manager.get_entity_destination(wh))
				current_state = Enums.STATE.MOVING
				break
		wh = game.entity_manager.find_entity(wh, e_type)
		
	if wh == null:
		# not found, wait a bit before checking again
		print("No resource_drop found!")
		work_time -= 1
		return false
		
	return true

func has_resources() -> bool:
	if unit_type == Enums.UNIT_TYPE.CIVILIAN:
		if resources.get_resource_value(workplace_resource_type) > 0:
			return true
	elif unit_type == Enums.UNIT_TYPE.MILITARY:
		for key in game.data.items[entity_type].required_resources:
			var value_req = game.data.items[entity_type].required_resources[key]
			if self.resources.get_resource_value(key, true) < value_req:
				return false
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
			# sometimes we get stuck in a loop, let's measure distance to final position
			if is_near(destination):
				on_target_reached()
			# TODO - eventually we should just change position or stop the body
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
