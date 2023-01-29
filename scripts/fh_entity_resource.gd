extends fh_entity
class_name fh_entity_resource

@onready var mesh: MeshInstance3D = get_node("MeshInstance3D")
@onready var body: StaticBody3D = $MeshInstance3D/StaticBody3D

var resources_per_action_complete: int = 10
var progress_per_action: int = 10
@onready var game = get_node("/root/game")
var total_progress: int = 0

@export var resource_type: Enums.RESOURCE = Enums.RESOURCE.NOT_SET

# Called when the node enters the scene tree for the first time.
func _ready():
	resources.set_resource(resource_type, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action_performed() -> int:
	total_progress += progress_per_action
	if (total_progress >= 100):
		# action complete
		total_progress = 0
		var resources_left = resources.get_resource_value(resource_type)
		var val = resources_per_action_complete if resources_left >= resources_per_action_complete else resources_left
		resources_left -= val
		
		resources.set_resource(resource_type, resources_left)
		if resources_left <= 0:
			die()
		return val
	return 0

func die():
	game.entity_manager.remove_entity(self)
