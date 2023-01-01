extends Node
class_name fh_entity

@export var team_no: int = 0
@export var entity_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
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
			Enums.ENTITY.UNIT_UNEMPLOYED:
				return Enums.ENTITY_CATEGORY.UNIT
			Enums.ENTITY.UNIT_WOODCHOPPER:
				return Enums.ENTITY_CATEGORY.UNIT
			Enums.ENTITY.RESOURCE_TREE:
				return Enums.ENTITY_CATEGORY.RESOURCE
		
		return Enums.ENTITY_CATEGORY.NOT_SET
var player_owner: fh_player = null
@onready var entry: Node3D = get_node_or_null("entry")
@onready var gather_area: StaticBody3D = get_node_or_null("gather_area")
var occupied: bool = false
var resources: fh_resources = fh_resources.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


