extends Node
class_name fh_entity

@export var team_no: int = 0
@export var entity_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
var entity_category: Enums.ENTITY_CATEGORY:
	get:
		return fh_entity.get_entity_category(entity_type)
var player_owner: fh_player = null
@onready var entry: Node3D = get_node_or_null("entry")
@onready var gather_area: StaticBody3D = get_node_or_null("gather_area")
var occupied: bool = false
var resources: fh_resources = fh_resources.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

static func get_entity_category(ent_type) -> Enums.ENTITY_CATEGORY:
	match ent_type:
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

static func get_work_target_type(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY.RESOURCE_TREE
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY.RESOURCE_STONE
			
	return Enums.ENTITY.NOT_SET


static func get_entity_type_resource(ent_type: Enums.ENTITY):
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.RESOURCE.WOOD
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.RESOURCE.STONE
			
	return Enums.RESOURCE.NOT_SET
	
static func get_entity_type_processed_resource(ent_type: Enums.ENTITY):
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.RESOURCE.WOODEN_PLANKS
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.RESOURCE.STONE
			
	return Enums.RESOURCE.NOT_SET

static func get_max_resources(ret_res, ent_type: Enums.ENTITY) -> fh_resources:
	if ret_res == null:
		ret_res = fh_resources.new()
	
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			ret_res.wood = 10
			ret_res.wooden_planks = 10
		Enums.ENTITY.UNIT_QUARRYWORKER:
			ret_res.stone = 10
			
	return ret_res

static func get_occupation(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.BUILDING_WOODCHOPPER:
			return Enums.ENTITY.UNIT_WOODCHOPPER
		Enums.ENTITY.BUILDING_QUARRY:
			return Enums.ENTITY.UNIT_QUARRYWORKER
			
	return Enums.ENTITY.NOT_SET

static func get_entity_required_resources(ent_type: Enums.ENTITY) -> fh_resources:
	var required_resources = fh_resources.new()
	match ent_type:
		Enums.ENTITY.BUILDING_WOODCHOPPER:
			required_resources.wooden_planks = 20
		Enums.ENTITY.BUILDING_WAREHOUSE:
			required_resources.wooden_planks = 100
		Enums.ENTITY.BUILDING_QUARRY:
			required_resources.wooden_planks = 150
	return required_resources
