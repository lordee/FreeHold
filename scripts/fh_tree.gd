extends Node3D
#class_name fh_tree # FIXME - x is fh_tree not working on raycast here, so we will use groups

var resources: fh_resources = fh_resources.new()
var resources_per_action_complete: int = 10
var progress_per_action: int = 5

# state
var total_progress: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$tree2/StaticBody3d.add_to_group("fh_tree")
	resources.wood = 50

func action_performed(unit: Unit):
	total_progress += progress_per_action
	if (total_progress >= 100):
		# action complete
		total_progress = 0
		var val = resources_per_action_complete if resources.wood >= resources_per_action_complete else resources.wood
		resources.wood -= val
		unit.add_resource(Enums.RESOURCE.wood, val)
		if resources.wood <= 0:
			die()

func die():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
