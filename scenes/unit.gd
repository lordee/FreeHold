extends CharacterBody3D
class_name Unit
# nodes
var selector: MeshInstance3D
var agent: NavigationAgent3D

var SPEED: float = .2

# state
var destination: Vector3
var destination_set: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	selector = get_node("selector")
	agent = get_node("NavigationAgent3d")
	agent.velocity_computed.connect(on_velocity_computed)
	agent.path_changed.connect(on_path_changed)
	agent.target_reached.connect(on_target_reached)

func _physics_process(delta: float) -> void:
	if is_on_floor() and destination_set:
		if agent.is_target_reachable():
			var next_location = agent.get_next_location()
			var v = global_transform.origin.direction_to(next_location).normalized() * SPEED
			#var v = (next_location - self.global_position).normalized()
			agent.set_velocity(v)
		else:
			agent.set_velocity(Vector3.ZERO)
	else:
		velocity.y -= gravity * delta
		move_and_slide()

func move_to(dest: Vector3) -> void:
	destination = dest
	destination_set = true
	agent.set_target_location(destination)

func select():
	selector.show()
	
func deselect():
	selector.hide()

func on_path_changed() -> void:
	print("dest: " + str(destination))
	print(agent.get_nav_path())

func on_velocity_computed(safe_velocity: Vector3) -> void:
	position += safe_velocity

func on_target_reached() -> void:
	destination_set = false
