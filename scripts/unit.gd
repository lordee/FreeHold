extends CharacterBody3D
class_name Unit
# nodes
var selector: MeshInstance3D
var agent: NavigationAgent3D

var SPEED: float = .2

# state
var destination: Vector3
var resources: fh_resources = fh_resources.new()
var max_resources: fh_resources = fh_resources.new() # TODO
var current_state: Enums.STATE = Enums.STATE.IDLE
var unit_type: Enums.UNIT_TYPE = Enums.UNIT_TYPE.CIVILIAN
var job_type: Enums.JOB_TYPE = Enums.JOB_TYPE.UNEMPLOYED
var workplace

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	selector = get_node("selector")
	agent = get_node("NavigationAgent3d")
	agent.velocity_computed.connect(on_velocity_computed)
	agent.path_changed.connect(on_path_changed)
	agent.target_reached.connect(on_target_reached)
	max_resources.wood = 10

func _physics_process(delta: float) -> void:
	
	match current_state:
		Enums.STATE.IDLE:
			if job_type == Enums.JOB_TYPE.UNEMPLOYED:
				continue
				
			if unit_type == Enums.UNIT_TYPE.CIVILIAN:
				go_to_work_building()
			elif unit_type == Enums.UNIT_TYPE.MILITARY:
				continue # TODO
		Enums.STATE.MOVING:
			if is_on_floor():
				if agent.is_target_reachable():
					var next_location = agent.get_next_location()
					var v = global_transform.origin.direction_to(next_location).normalized() * SPEED
					agent.set_velocity(v)
					# FIXME - maintain angles/y rotation
					look_at(next_location)
				else:
					agent.set_velocity(Vector3.ZERO)
			else:
				velocity.y -= gravity * delta
				move_and_slide()

func go_to_work_building():
	move_to(workplace.global_transform.origin)

func add_resource(resource_type: Enums.RESOURCE, val: int):
	resources.add_resource(resource_type, val)
	# TODO - carrying animation
	go_to_work_building()

func move_to(dest: Vector3) -> void:
	destination = dest
	current_state = Enums.STATE.MOVING
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
