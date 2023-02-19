extends Object
class_name fh_resources

var MAX_PILE_AMOUNT: int = 1000
var MAX_PILES: int = 16

var wood: int = 0
var gold: int = 0
var stone: int = 0
var flour: int = 0
var wooden_planks: int = 0
var iron: int = 0
var fruit: int = 0
var vegetable: int = 0
var wheat: int = 0
var bread: int = 0
var cheese: int = 0
var milk: int = 0
var pig: int = 0
var meat: int = 0

var reserved_resources: fh_resources = null
var reserved_resources_dict: Dictionary = {}

func add_resource(e_type: Enums.ENTITY, val: int):
	match e_type:
		Enums.ENTITY.RESOURCE_WOOD:
			wood += val
		Enums.ENTITY.RESOURCE_GOLD:
			gold += val
		Enums.ENTITY.RESOURCE_STONE:
			stone += val
		Enums.ENTITY.RESOURCE_FLOUR:
			flour += val 
		Enums.ENTITY.RESOURCE_WOODEN_PLANKS:
			wooden_planks += val
		Enums.ENTITY.RESOURCE_IRON:
			iron += val
		Enums.ENTITY.RESOURCE_FRUIT:
			fruit += val
		Enums.ENTITY.RESOURCE_VEGETABLE:
			vegetable += val
		Enums.ENTITY.RESOURCE_WHEAT:
			wheat += val
		Enums.ENTITY.RESOURCE_BREAD:
			bread += val
		Enums.ENTITY.RESOURCE_CHEESE:
			cheese += val
		Enums.ENTITY.RESOURCE_MILK:
			milk += val
		Enums.ENTITY.RESOURCE_PIG:
			pig += val
		Enums.ENTITY.RESOURCE_MEAT:
			meat += val
		Enums.ENTITY.NOT_SET:
			print("resource not set passed to add_resource")
			
func set_resource(e_type: Enums.ENTITY, val: int):
	match e_type:
		Enums.ENTITY.RESOURCE_WOOD:
			wood = val
		Enums.ENTITY.RESOURCE_GOLD:
			gold = val
		Enums.ENTITY.RESOURCE_STONE:
			stone = val
		Enums.ENTITY.RESOURCE_FLOUR:
			flour = val 
		Enums.ENTITY.RESOURCE_WOODEN_PLANKS:
			wooden_planks = val
		Enums.ENTITY.RESOURCE_IRON:
			iron = val
		Enums.ENTITY.RESOURCE_FRUIT:
			fruit = val
		Enums.ENTITY.RESOURCE_VEGETABLE:
			vegetable = val
		Enums.ENTITY.RESOURCE_WHEAT:
			wheat = val
		Enums.ENTITY.RESOURCE_BREAD:
			bread = val
		Enums.ENTITY.RESOURCE_CHEESE:
			cheese = val
		Enums.ENTITY.RESOURCE_MILK:
			milk = val
		Enums.ENTITY.RESOURCE_PIG:
			pig = val
		Enums.ENTITY.RESOURCE_MEAT:
			meat = val
		Enums.ENTITY.NOT_SET:
			print("resource not set passed to set_resource")

func merge_resource_objects(external_resource: fh_resources, add: bool):
	var multiplier = 1
	if !add:
		multiplier = -1
		
	add_resource(Enums.ENTITY.RESOURCE_WOOD, external_resource.wood * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_GOLD, external_resource.gold * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_STONE, external_resource.stone * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_FLOUR, external_resource.flour * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_WOODEN_PLANKS, external_resource.wooden_planks * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_IRON, external_resource.iron * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_FRUIT, external_resource.fruit * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_VEGETABLE, external_resource.vegetable * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_WHEAT, external_resource.wheat * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_BREAD, external_resource.bread * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_CHEESE, external_resource.cheese * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_MILK, external_resource.milk * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_PIG, external_resource.pig * multiplier)
	add_resource(Enums.ENTITY.RESOURCE_MEAT, external_resource.meat * multiplier)

func get_resource_value(e_type: Enums.ENTITY, include_reserved: bool = true) -> int:
	if reserved_resources == null:
		reserved_resources = fh_resources.new()
		
	match e_type:
		Enums.ENTITY.RESOURCE_TREE:
			return wood if include_reserved else wood - reserved_resources.wood
		Enums.ENTITY.RESOURCE_WOOD:
			return wood if include_reserved else wood - reserved_resources.wood
		Enums.ENTITY.RESOURCE_GOLD:
			return gold if include_reserved else gold - reserved_resources.gold
		Enums.ENTITY.RESOURCE_STONE:
			return stone if include_reserved else stone - reserved_resources.stone
		Enums.ENTITY.RESOURCE_FLOUR:
			return flour if include_reserved else flour - reserved_resources.flour
		Enums.ENTITY.RESOURCE_WOODEN_PLANKS:
			return wooden_planks if include_reserved else wooden_planks - reserved_resources.wooden_planks
		Enums.ENTITY.RESOURCE_IRON:
			return iron if include_reserved else iron - reserved_resources.iron
		Enums.ENTITY.RESOURCE_FRUIT:
			return fruit if include_reserved else fruit - reserved_resources.fruit
		Enums.ENTITY.RESOURCE_VEGETABLE:
			return vegetable if include_reserved else vegetable - reserved_resources.vegetable
		Enums.ENTITY.RESOURCE_WHEAT:
			return wheat if include_reserved else wheat - reserved_resources.wheat
		Enums.ENTITY.RESOURCE_BREAD:
			return bread if include_reserved else bread - reserved_resources.bread
		Enums.ENTITY.RESOURCE_CHEESE:
			return cheese if include_reserved else cheese - reserved_resources.cheese
		Enums.ENTITY.RESOURCE_MILK:
			return milk if include_reserved else milk - reserved_resources.milk
		Enums.ENTITY.RESOURCE_PIG:
			return pig if include_reserved else pig - reserved_resources.pig
		Enums.ENTITY.RESOURCE_MEAT:
			return meat if include_reserved else meat - reserved_resources.meat
			
	print("get_resource_value enum not found")
	return 0

func collect_resource(requester: fh_unit, e_type: Enums.ENTITY, value: int) -> bool:
	if reserved_resources_dict.has(requester.name):
		# i'm sure this will be a bug some day, but we only have people requesting/reserving a single resource at a time
		# unreserve everything, allowing us to query the pool of resources
		for key in reserved_resources_dict[requester.name]:
			var val: int = reserved_resources_dict[requester.name][key]
			unreserve_resource(key, val)
		reserved_resources_dict[requester.name] = {}

	var val_avail: int = get_resource_value(e_type, false)
	
	var total_resources: int = value if value <= val_avail else val_avail
	val_avail = val_avail - total_resources
	set_resource(e_type, val_avail)
	
	# shouldn't be doing this here
	requester.resources.add_resource(e_type, total_resources)
	
	if total_resources > 0:
		return true
	else:
		return false

func reserve_resource(requester: fh_unit, e_type: Enums.ENTITY, value: int) -> bool: # TODO maybe return value instead, but we do all or nothing for now
	if reserved_resources == null:
		reserved_resources = fh_resources.new()
	var val_avail: int = get_resource_value(e_type, false)
	
	var res_value: int = value if val_avail >= value else val_avail
	
	reserved_resources.add_resource(e_type, res_value)
	
	if !reserved_resources_dict.has(requester.name):
		reserved_resources_dict[requester.name] = {}
		
	for key in reserved_resources_dict[requester.name]:
		unreserve_resource(key, res_value)
	reserved_resources_dict[requester.name] = {}
	reserved_resources_dict[requester.name][e_type] = res_value
	
	var val_left: int = val_avail - res_value
	set_resource(e_type, val_left)
	
	return true

func unreserve_resource(e_type: Enums.ENTITY, value: int):
	var res_val: int = reserved_resources.get_resource_value(e_type)
	res_val = res_val - value
	reserved_resources.set_resource(e_type, res_val)
	
	var val_avail = get_resource_value(e_type, false)
	val_avail = val_avail + res_val + value
	add_resource(e_type, val_avail)

# at the moment, warehouse specific
func space_left(e_type: Enums.ENTITY) -> int:
	# add up number of unique resources
	# figure out number of piles within resources
	# count the piles
	# if empty pile, has space
	# if no empty piles, are any piles not full?
	var piles: int = 0
	if wood > 0:
		piles += int(ceil(float(wood) / float(MAX_PILE_AMOUNT)))
	if gold > 0:
		piles += int(ceil(float(gold) / float(MAX_PILE_AMOUNT)))
	if stone > 0:
		piles += int(ceil(float(stone) / float(MAX_PILE_AMOUNT)))
	if flour > 0:
		piles += int(ceil(float(flour) / float(MAX_PILE_AMOUNT)))
	if wooden_planks > 0:
		piles += int(ceil(float(wooden_planks) / float(MAX_PILE_AMOUNT)))
	if iron > 0:
		piles += int(ceil(float(iron) / float(MAX_PILE_AMOUNT)))
	if fruit > 0:
		piles += int(ceil(float(fruit) / float(MAX_PILE_AMOUNT)))
	if vegetable > 0:
		piles += int(ceil(float(vegetable) / float(MAX_PILE_AMOUNT)))
	if wheat > 0:
		piles += int(ceil(float(wheat) / float(MAX_PILE_AMOUNT)))
	if bread > 0:
		piles += int(ceil(float(bread) / float(MAX_PILE_AMOUNT)))
	if cheese > 0:
		piles += int(ceil(float(cheese) / float(MAX_PILE_AMOUNT)))
	if milk > 0:
		piles += int(ceil(float(milk) / float(MAX_PILE_AMOUNT)))
	if pig > 0:
		piles += int(ceil(float(pig) / float(MAX_PILE_AMOUNT)))
	if meat > 0:
		piles += int(ceil(float(meat) / float(MAX_PILE_AMOUNT)))
	
	if piles < MAX_PILES:
		return (MAX_PILES - piles) * MAX_PILE_AMOUNT
	else:
		var res_val = get_resource_value(e_type)
		var rem = res_val % MAX_PILE_AMOUNT
		return rem
	
