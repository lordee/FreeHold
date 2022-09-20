extends Node

class_name EntityManager

var entities: Array = Array()
var selected_entities: Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populate_entities():
	# for testing
	var u: Unit = get_node_or_null("/root/game/map/unit")
	if u != null:
		entities.append(u)

func select_object(object):
	var selector: MeshInstance3D = object.get_node_or_null("selector")
	if selector == null:
		return
		
	selector.show()
	selected_entities.append(object)
		
	
func deselect_all():
	for ent in selected_entities:
		var selector: MeshInstance3D = ent.get_node_or_null("selector")
		if selector == null:
			return
			
		selector.hide()

func move_selected_units(dest_position: Vector3):
	for ent in selected_entities:
		ent.destination = dest_position
