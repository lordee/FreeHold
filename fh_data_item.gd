extends Object

class_name fh_data_item

var entity_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
var entity_category: Enums.ENTITY_CATEGORY = Enums.ENTITY_CATEGORY.NOT_SET
var resource_level_one: Enums.ENTITY = Enums.ENTITY.NOT_SET
var resource_level_one_collection_point: Enums.RESOURCE_PROCESS_POINT = Enums.RESOURCE_PROCESS_POINT.NOT_SET
var resource_level_one_dropoff_point: Enums.RESOURCE_PROCESS_POINT = Enums.RESOURCE_PROCESS_POINT.NOT_SET
var resource_level_one_max_carry: int = 0
var resource_level_two: Enums.ENTITY = Enums.ENTITY.NOT_SET
var resource_level_two_collection_point: Enums.RESOURCE_PROCESS_POINT = Enums.RESOURCE_PROCESS_POINT.NOT_SET
var resource_level_two_dropoff_point: Enums.RESOURCE_PROCESS_POINT = Enums.RESOURCE_PROCESS_POINT.NOT_SET
var resource_level_two_max_carry: int = 0
var unit_type: Enums.UNIT_TYPE = Enums.UNIT_TYPE.NOT_SET
var worker_type: Enums.ENTITY
var required_resources: Dictionary = {}
var scene: PackedScene = null

func process_building(
		e_type: Enums.ENTITY, 
		e_category: Enums.ENTITY_CATEGORY, 
		w_type: Enums.ENTITY,
		req_resources: Dictionary,
		scene_string: String
	):
	entity_type = e_type
	entity_category = e_category
	worker_type = w_type
	required_resources = req_resources
	if len(scene_string) > 0:
		scene = ResourceLoader.load(scene_string)

func process_military_unit(
	e_type: Enums.ENTITY, 
	e_category: Enums.ENTITY_CATEGORY, 
	u_type: Enums.UNIT_TYPE,
	req_resources: Dictionary,
	scene_string: String
):
	entity_type = e_type
	entity_category = e_category
	unit_type = u_type
	required_resources = req_resources
	if len(scene_string) > 0:
		scene = ResourceLoader.load(scene_string)

func process_unit(
		e_type: Enums.ENTITY, 
		e_category: Enums.ENTITY_CATEGORY, 
		res_level_one: Enums.ENTITY, 
		res_level_one_collection_point: Enums.RESOURCE_PROCESS_POINT,
		res_level_one_dropoff_point: Enums.RESOURCE_PROCESS_POINT,
		res_level_one_max_carry: int,
		res_level_two: Enums.ENTITY,
		res_level_two_collection_point: Enums.RESOURCE_PROCESS_POINT,
		res_level_two_dropoff_point: Enums.RESOURCE_PROCESS_POINT,
		res_level_two_max_carry: int,
		u_type: Enums.UNIT_TYPE,
	):
				
	entity_type = e_type
	entity_category = e_category
	resource_level_one = res_level_one
	resource_level_one_collection_point = res_level_one_collection_point
	resource_level_one_dropoff_point = res_level_one_dropoff_point
	resource_level_two = res_level_two
	resource_level_two_collection_point = res_level_two_collection_point
	resource_level_two_dropoff_point = res_level_two_dropoff_point
	unit_type = u_type
	resource_level_one_max_carry = res_level_one_max_carry
	resource_level_two_max_carry = res_level_two_max_carry
	var scene_string = "res://scenes/unit.tscn"
	if len(scene_string) > 0:
		scene = ResourceLoader.load(scene_string)

func process_resource(
		e_type: Enums.ENTITY, 
		e_category: Enums.ENTITY_CATEGORY, 
	):
	entity_type = e_type
	entity_category = e_category
