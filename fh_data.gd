extends Object

class_name fh_data

var items: Dictionary = {}

# TODO - i just want a struct...

#	SCENES[Enums.ENTITY.RESOURCE_TREE] = ResourceLoader.load("res://scenes/tree.tscn")
#	SCENES[Enums.ENTITY.RESOURCE_STONE] = ResourceLoader.load("res://scenes/stone.tscn")
#	SCENES[Enums.ENTITY.UNIT_UNEMPLOYED] = ResourceLoader.load("res://scenes/unit.tscn")


func _init():
	add_building(
			Enums.ENTITY.BUILDING_CASTLE, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.NOT_SET,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			""
			)
	add_building(
			Enums.ENTITY.BUILDING_WOODCHOPPER, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_WOODCHOPPER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/woodchopper.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_WAREHOUSE, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.NOT_SET,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/warehouse.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_QUARRY, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_QUARRYWORKER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/quarry.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_IRONMINE, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_IRONMINER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/iron_mine.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_ORCHARD, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_ORCHARDWORKER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/orchard.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_VEGETABLEFARM, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_VEGETABLEFARMER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/vegetable_farm.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_WHEATFARM, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_WHEATFARMER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/wheat_farm.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_WINDMILL, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_MILLWORKER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/windmill.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_BAKERY, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_BAKER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/bakery.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_DAIRYFARM, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_DAIRYFARMER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/dairy_farm.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_PIGFARM, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_PIGFARMER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/pig_farm.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_HOPSFARM, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_HOPSFARMER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/hops_farm.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_BREWERY, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_BREWER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/brewery.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_TAVERN, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_INNKEEPER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/tavern.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_CHANDLERY, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_CHANDLER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/chandlery.tscn"
			)
	add_building(
			Enums.ENTITY.BUILDING_CHURCH, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_PRIEST,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/church.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_PITCHWORKSHOP, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_PITCHGATHERER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/pitch_workshop.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_FLETCHERWORKSHOP, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.UNIT_FLETCHER,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/fletcher_workshop.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_ARMOURY, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.NOT_SET,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/armoury.tscn",
			)
	add_building(
			Enums.ENTITY.BUILDING_BARRACKS, 
			Enums.ENTITY_CATEGORY.BUILDING,
			Enums.ENTITY.NOT_SET,
			{Enums.ENTITY.RESOURCE_WOODEN_PLANKS: 50},
			"res://scenes/buildings/barracks.tscn",
			)
	

	add_unit(
			Enums.ENTITY.UNIT_UNEMPLOYED, 
			Enums.ENTITY_CATEGORY.UNIT,
			Enums.ENTITY.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.NOT_SET,
			0,
			Enums.ENTITY.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.NOT_SET,
			0,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_WOODCHOPPER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_TREE, 
			Enums.RESOURCE_PROCESS_POINT.MAP,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_WOODEN_PLANKS,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_QUARRYWORKER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_STONE_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.MAP,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_STONE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_IRONMINER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_IRON_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.MAP,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_IRON,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_ORCHARDWORKER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_FRUIT_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_FRUIT,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_VEGETABLEFARMER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_VEGETABLE_PRECURSOR,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_VEGETABLE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_WHEATFARMER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_WHEAT_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_WHEAT,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_MILLWORKER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_WHEAT,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_FLOUR,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_BAKER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_FLOUR, 
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_BREAD,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_DAIRYFARMER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_MILK, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_CHEESE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_PIGFARMER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_PIG, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_MEAT,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_HOPSFARMER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_HOPS_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_HOPS,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_BREWER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_HOPS, 
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_ALE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_INNKEEPER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_ALE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			0,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_CHANDLER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_CANDLE_PRECURSOR, 
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_CANDLES,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_PRIEST, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_CANDLES,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.NOT_SET,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			0,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_PITCHGATHERER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_PITCH_PRECURSOR,
			Enums.RESOURCE_PROCESS_POINT.MAP,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_PITCH,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	add_unit(
			Enums.ENTITY.UNIT_FLETCHER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.ENTITY.RESOURCE_WOODEN_PLANKS,
			Enums.RESOURCE_PROCESS_POINT.WAREHOUSE,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			10,
			Enums.ENTITY.RESOURCE_BOW,
			Enums.RESOURCE_PROCESS_POINT.WORKPLACE,
			Enums.RESOURCE_PROCESS_POINT.ARMOURY,
			10,
			Enums.UNIT_TYPE.CIVILIAN
			)
	
	
	add_military_unit(
			Enums.ENTITY.UNIT_ARCHER, 
			Enums.ENTITY_CATEGORY.UNIT, 
			Enums.UNIT_TYPE.MILITARY,
			{Enums.ENTITY.RESOURCE_BOW: 1},
			"res://scenes/units/archer.tscn",
		)

	add_resource(Enums.ENTITY.RESOURCE_TREE, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_STONE, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_STONE_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_IRON, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_IRON_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_FRUIT, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_FRUIT_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_VEGETABLE, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_VEGETABLE_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_WHEAT, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_WHEAT_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_FLOUR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_BREAD, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_CHEESE, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_MILK, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_PIG, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_MEAT, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_HOPS, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_HOPS_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_ALE, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_CANDLES, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_CANDLE_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_PITCH, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_PITCH_PRECURSOR, Enums.ENTITY_CATEGORY.RESOURCE)
	add_resource(Enums.ENTITY.RESOURCE_BOW, Enums.ENTITY_CATEGORY.RESOURCE)

func add_building(
		entity_type: Enums.ENTITY, 
		entity_category: Enums.ENTITY_CATEGORY, 
		unit_type: Enums.ENTITY,
		required_resources: Dictionary,
		scene_string: String
	):
	
	var ent_item: fh_data_item = fh_data_item.new()
	ent_item.process_building(
		entity_type, 
		entity_category,
		unit_type,
		required_resources,
		scene_string,
	)
	items[entity_type] = ent_item

func add_military_unit(
	entity_type: Enums.ENTITY, 
	entity_category: Enums.ENTITY_CATEGORY, 
	unit_type: Enums.UNIT_TYPE,
	required_resources: Dictionary,
	scene_string: String
):
	var ent_item: fh_data_item = fh_data_item.new()
	ent_item.process_military_unit(
		entity_type, 
		entity_category,
		unit_type,
		required_resources,
		scene_string
	)
	
	items[entity_type] = ent_item

func add_unit(
		entity_type: Enums.ENTITY, 
		entity_category: Enums.ENTITY_CATEGORY, 
		res_level_one: Enums.ENTITY, 
		res_level_one_collect: Enums.RESOURCE_PROCESS_POINT,
		res_level_one_dropoff: Enums.RESOURCE_PROCESS_POINT,
		res_level_one_max_carry: int,
		res_level_two: Enums.ENTITY,
		res_level_two_collect: Enums.RESOURCE_PROCESS_POINT,
		res_level_two_dropoff: Enums.RESOURCE_PROCESS_POINT,
		res_level_two_max_carry: int,
		unit_type: Enums.UNIT_TYPE,
	):
	var ent_item: fh_data_item = fh_data_item.new()
	ent_item.process_unit(
		entity_type, 
		entity_category,
		res_level_one,
		res_level_one_collect,
		res_level_one_dropoff,
		res_level_one_max_carry,
		res_level_two,
		res_level_two_collect,
		res_level_two_dropoff,
		res_level_two_max_carry,
		unit_type
	)
	
	items[entity_type] = ent_item

func add_resource(
		entity_type: Enums.ENTITY, 
		entity_category: Enums.ENTITY_CATEGORY
	):
	var ent_item: fh_data_item = fh_data_item.new()
	ent_item.process_resource(
		entity_type, 
		entity_category,
	)
	items[entity_type] = ent_item
