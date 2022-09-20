extends CharacterBody3D
class_name Unit
# nodes
var selector: MeshInstance3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	selector = get_node("selector")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

func select():
	selector.show()
	
func deselect():
	selector.hide()
