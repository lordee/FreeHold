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
var resource_nodes

var time: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var res = get_node_or_null("resources")
	if res != null:
		resource_nodes = res.get_children(true)

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
		Enums.ENTITY.BUILDING_IRONMINE:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_ORCHARD:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_VEGETABLEFARM:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_WHEATFARM:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_WINDMILL:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_BAKERY:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_DAIRYFARM:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_PIGFARM:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_HOPSFARM:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_BREWERY:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_TAVERN:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_CHANDLERY:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_CHURCH:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.BUILDING_PITCHWORKSHOP:
			return Enums.ENTITY_CATEGORY.BUILDING
		Enums.ENTITY.UNIT_UNEMPLOYED:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_WHEATFARMER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_BAKER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_DAIRYFARMER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_PIGFARMER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_HOPSFARMER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_BREWER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_INNKEEPER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_CHANDLER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_PRIEST:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.UNIT_PITCHGATHERER:
			return Enums.ENTITY_CATEGORY.UNIT
		Enums.ENTITY.RESOURCE_TREE:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_STONE:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_IRON:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_FRUIT:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_VEGETABLE:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_WHEAT:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_FLOUR:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_BREAD:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_CHEESE:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_MILK:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_PIG:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_MEAT:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_HOPS:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_ALE:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_CANDLES:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_CANDLE_PRECURSOR:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_PITCH:
			return Enums.ENTITY_CATEGORY.RESOURCE
		Enums.ENTITY.RESOURCE_PITCH_PRECURSOR:
			return Enums.ENTITY_CATEGORY.RESOURCE
		
	
	return Enums.ENTITY_CATEGORY.NOT_SET

static func is_resource_producer(e_type: Enums.ENTITY) -> bool:
	match e_type:
		Enums.ENTITY.BUILDING_ORCHARD:
			return true
		Enums.ENTITY.BUILDING_VEGETABLEFARM:
			return true
		Enums.ENTITY.BUILDING_WHEATFARM:
			return true
		Enums.ENTITY.BUILDING_DAIRYFARM:
			return true
		Enums.ENTITY.BUILDING_PIGFARM:
			return true
		Enums.ENTITY.BUILDING_HOPSFARM:
			return true
		Enums.ENTITY.BUILDING_CHANDLERY:
			return true
			
	return false

static func get_work_target_type(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY.RESOURCE_TREE
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY.RESOURCE_STONE
		Enums.ENTITY.UNIT_IRONMINER:
			return Enums.ENTITY.RESOURCE_IRON
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			return Enums.ENTITY.RESOURCE_FRUIT
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			return Enums.ENTITY.RESOURCE_VEGETABLE
		Enums.ENTITY.UNIT_WHEATFARMER:
			return Enums.ENTITY.RESOURCE_WHEAT
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.ENTITY.RESOURCE_WHEAT
		Enums.ENTITY.UNIT_BAKER:
			return Enums.ENTITY.RESOURCE_FLOUR
		Enums.ENTITY.UNIT_DAIRYFARMER:
			return Enums.ENTITY.RESOURCE_MILK
		Enums.ENTITY.UNIT_PIGFARMER:
			return Enums.ENTITY.RESOURCE_PIG
		Enums.ENTITY.UNIT_HOPSFARMER:
			return Enums.ENTITY.RESOURCE_HOPS
		Enums.ENTITY.UNIT_BREWER:
			return Enums.ENTITY.RESOURCE_HOPS
		Enums.ENTITY.UNIT_INNKEEPER:
			return Enums.ENTITY.RESOURCE_ALE
		Enums.ENTITY.UNIT_CHANDLER:
			return Enums.ENTITY.RESOURCE_CANDLE_PRECURSOR
		Enums.ENTITY.UNIT_PRIEST:
			return Enums.ENTITY.RESOURCE_CANDLES
		Enums.ENTITY.UNIT_PITCHGATHERER:
			return Enums.ENTITY.RESOURCE_PITCH_PRECURSOR
			
	return Enums.ENTITY.NOT_SET

# todo - how is this diff to work target type?
static func get_entity_type_resource(ent_type: Enums.ENTITY):
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY.RESOURCE_WOOD
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY.RESOURCE_STONE
		Enums.ENTITY.UNIT_IRONMINER:
			return Enums.ENTITY.RESOURCE_IRON
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			return Enums.ENTITY.RESOURCE_FRUIT
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			return Enums.ENTITY.RESOURCE_VEGETABLE
		Enums.ENTITY.UNIT_WHEATFARMER:
			return Enums.ENTITY.RESOURCE_WHEAT
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.ENTITY.RESOURCE_WHEAT
		Enums.ENTITY.UNIT_BAKER:
			return Enums.ENTITY.RESOURCE_FLOUR
		Enums.ENTITY.UNIT_DAIRYFARMER:
			return Enums.ENTITY.RESOURCE_MILK
		Enums.ENTITY.UNIT_PIGFARMER:
			return Enums.ENTITY.RESOURCE_PIG
		Enums.ENTITY.UNIT_HOPSFARMER:
			return Enums.ENTITY.RESOURCE_HOPS
		Enums.ENTITY.UNIT_BREWER:
			return Enums.ENTITY.RESOURCE_HOPS
		Enums.ENTITY.UNIT_INNKEEPER:
			return Enums.ENTITY.RESOURCE_ALE
		Enums.ENTITY.UNIT_CHANDLER:
			return Enums.ENTITY.RESOURCE_CANDLE_PRECURSOR
		Enums.ENTITY.UNIT_PRIEST:
			return Enums.ENTITY.RESOURCE_CANDLES
		Enums.ENTITY.UNIT_PITCHGATHERER:
			return Enums.ENTITY.RESOURCE_PITCH_PRECURSOR
			
	return Enums.ENTITY.NOT_SET
	
static func get_entity_type_processed_resource(ent_type: Enums.ENTITY):
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.ENTITY.RESOURCE_WOODEN_PLANKS
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.ENTITY.RESOURCE_STONE
		Enums.ENTITY.UNIT_IRONMINER:
			return Enums.ENTITY.RESOURCE_IRON
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			return Enums.ENTITY.RESOURCE_FRUIT
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			return Enums.ENTITY.RESOURCE_VEGETABLE
		Enums.ENTITY.UNIT_WHEATFARMER:
			return Enums.ENTITY.RESOURCE_WHEAT
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.ENTITY.RESOURCE_FLOUR
		Enums.ENTITY.UNIT_BAKER:
			return Enums.ENTITY.RESOURCE_BREAD
		Enums.ENTITY.UNIT_DAIRYFARMER:
			return Enums.ENTITY.RESOURCE_CHEESE
		Enums.ENTITY.UNIT_PIGFARMER:
			return Enums.ENTITY.RESOURCE_MEAT
		Enums.ENTITY.UNIT_HOPSFARMER:
			return Enums.ENTITY.RESOURCE_HOPS
		Enums.ENTITY.UNIT_BREWER:
			return Enums.ENTITY.RESOURCE_ALE
		Enums.ENTITY.UNIT_CHANDLER:
			return Enums.ENTITY.RESOURCE_CANDLES
		Enums.ENTITY.UNIT_PITCHGATHERER:
			return Enums.ENTITY.RESOURCE_PITCH
			
	return Enums.ENTITY.NOT_SET

static func get_unit_type(ent_type: Enums.ENTITY) -> Enums.UNIT_TYPE:
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_UNEMPLOYED:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_QUARRYWORKER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_IRONMINER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_WHEATFARMER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_BAKER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_DAIRYFARMER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_PIGFARMER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_HOPSFARMER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_BREWER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_INNKEEPER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_CHANDLER:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_PRIEST:
			return Enums.UNIT_TYPE.CIVILIAN
		Enums.ENTITY.UNIT_PITCHGATHERER:
			return Enums.UNIT_TYPE.CIVILIAN

	return Enums.UNIT_TYPE.NOT_SET

# FIXME - merge with is_resource_provider for orchard, fruit farm, vegetable farm etc
static func resource_collection_point(e_type: Enums.ENTITY) -> Enums.RESOURCE_PROCESS_POINT:
	match e_type:
		Enums.ENTITY.UNIT_MILLWORKER:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.UNIT_BAKER:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.UNIT_BREWER:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.UNIT_INNKEEPER:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.UNIT_PRIEST:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		_:
			return Enums.RESOURCE_PROCESS_POINT.MAP

# TODO - i think we can remove processed resources from this list
static func resource_dropoff_point(e_type: Enums.ENTITY) -> Enums.RESOURCE_PROCESS_POINT:
	match e_type:
		Enums.ENTITY.RESOURCE_STONE:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_IRON:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_FRUIT:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_VEGETABLE:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_WHEAT:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_BREAD:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_CHEESE:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_MEAT:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		Enums.ENTITY.RESOURCE_HOPS:
			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
#		Enums.ENTITY.RESOURCE_CANDLES:
#			return Enums.RESOURCE_PROCESS_POINT.WAREHOUSE
		_:
			return Enums.RESOURCE_PROCESS_POINT.WORKPLACE

static func get_max_resources(ret_res, ent_type: Enums.ENTITY) -> fh_resources:
	if ret_res == null:
		ret_res = fh_resources.new()
	
	match ent_type:
		Enums.ENTITY.UNIT_WOODCHOPPER:
			ret_res.wood = 10
			ret_res.wooden_planks = 10
		Enums.ENTITY.UNIT_QUARRYWORKER:
			ret_res.stone = 10
		Enums.ENTITY.UNIT_IRONMINER:
			ret_res.iron = 10
		Enums.ENTITY.UNIT_ORCHARDWORKER:
			ret_res.fruit = 10
		Enums.ENTITY.UNIT_VEGETABLEFARMER:
			ret_res.vegetable = 10
		Enums.ENTITY.UNIT_WHEATFARMER:
			ret_res.wheat = 10
		Enums.ENTITY.UNIT_MILLWORKER:
			ret_res.wheat = 10
			ret_res.flour = 10
		Enums.ENTITY.UNIT_BAKER:
			ret_res.bread = 10
			ret_res.flour = 10
		Enums.ENTITY.UNIT_DAIRYFARMER:
			ret_res.milk = 10
			ret_res.cheese = 10
		Enums.ENTITY.UNIT_PIGFARMER:
			ret_res.pig = 10
			ret_res.meat = 10
		Enums.ENTITY.UNIT_HOPSFARMER:
			ret_res.hops = 10
		Enums.ENTITY.UNIT_BREWER:
			ret_res.hops = 10
			ret_res.ale = 10
		Enums.ENTITY.UNIT_INNKEEPER:
			ret_res.ale = 0
		Enums.ENTITY.UNIT_CHANDLER:
			ret_res.candles = 10
			ret_res.candle_precursor = 10
		Enums.ENTITY.UNIT_PRIEST:
			ret_res.candles = 0
		Enums.ENTITY.UNIT_PITCHGATHERER:
			ret_res.pitch = 10
			ret_res.pitch_precursor = 10
			
	return ret_res

static func get_occupation(e_type: Enums.ENTITY):
	match e_type:
		Enums.ENTITY.BUILDING_WOODCHOPPER:
			return Enums.ENTITY.UNIT_WOODCHOPPER
		Enums.ENTITY.BUILDING_QUARRY:
			return Enums.ENTITY.UNIT_QUARRYWORKER
		Enums.ENTITY.BUILDING_IRONMINE:
			return Enums.ENTITY.UNIT_IRONMINER
		Enums.ENTITY.BUILDING_ORCHARD:
			return Enums.ENTITY.UNIT_ORCHARDWORKER
		Enums.ENTITY.BUILDING_VEGETABLEFARM:
			return Enums.ENTITY.UNIT_VEGETABLEFARMER
		Enums.ENTITY.BUILDING_WHEATFARM:
			return Enums.ENTITY.UNIT_WHEATFARMER
		Enums.ENTITY.BUILDING_WINDMILL:
			return Enums.ENTITY.UNIT_MILLWORKER
		Enums.ENTITY.BUILDING_BAKERY:
			return Enums.ENTITY.UNIT_BAKER
		Enums.ENTITY.BUILDING_DAIRYFARM:
			return Enums.ENTITY.UNIT_DAIRYFARMER
		Enums.ENTITY.BUILDING_PIGFARM:
			return Enums.ENTITY.UNIT_PIGFARMER
		Enums.ENTITY.BUILDING_HOPSFARM:
			return Enums.ENTITY.UNIT_HOPSFARMER
		Enums.ENTITY.BUILDING_BREWERY:
			return Enums.ENTITY.UNIT_BREWER
		Enums.ENTITY.BUILDING_TAVERN:
			return Enums.ENTITY.UNIT_INNKEEPER
		Enums.ENTITY.BUILDING_CHANDLERY:
			return Enums.ENTITY.UNIT_CHANDLER
		Enums.ENTITY.BUILDING_CHURCH:
			return Enums.ENTITY.UNIT_PRIEST
		Enums.ENTITY.BUILDING_PITCHWORKSHOP:
			return Enums.ENTITY.UNIT_PITCHGATHERER
			
	return Enums.ENTITY.NOT_SET

static func get_entity_required_resources(ent_type: Enums.ENTITY) -> fh_resources:
	var required_resources = fh_resources.new()
	match ent_type:
		Enums.ENTITY.BUILDING_WOODCHOPPER:
			required_resources.wooden_planks = 20
		Enums.ENTITY.BUILDING_WAREHOUSE:
			required_resources.wooden_planks = 100
		Enums.ENTITY.BUILDING_IRONMINE:
			required_resources.wooden_planks = 150
		Enums.ENTITY.BUILDING_QUARRY:
			required_resources.wooden_planks = 100
		Enums.ENTITY.BUILDING_ORCHARD:
			required_resources.wooden_planks = 20
		Enums.ENTITY.BUILDING_VEGETABLEFARM:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_WHEATFARM:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_WINDMILL:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_BAKERY:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_DAIRYFARM:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_PIGFARM:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_HOPSFARM:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_BREWERY:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_TAVERN:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_CHANDLERY:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_CHURCH:
			required_resources.wooden_planks = 50
		Enums.ENTITY.BUILDING_PITCHWORKSHOP:
			required_resources.wooden_planks = 50
	return required_resources
