extends fh_entity
class_name fh_tree # FIXME - x is fh_tree not working on raycast here, so we will use groups

#var resources: fh_resources = fh_resources.new()
var resources_per_action_complete: int = 10
var progress_per_action: int = 10
@onready var game = get_node("/root/game")

# state
var total_progress: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$tree2/StaticBody3d.add_to_group("fh_tree")
	resources.wood = 50
	entity_type = Enums.ENTITY.RESOURCE_TREE

func action_performed() -> int:
	total_progress += progress_per_action
	if (total_progress >= 100):
		# action complete
		total_progress = 0
		var val = resources_per_action_complete if resources.wood >= resources_per_action_complete else resources.wood
		resources.wood -= val
		if resources.wood <= 0:
			die()
		return val
	return 0

func die():
	game.entity_manager.remove_entity(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
