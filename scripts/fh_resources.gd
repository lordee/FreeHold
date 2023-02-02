extends Object
class_name fh_resources

var MAX_PILE_AMOUNT: int = 1000
var MAX_PILES: int = 16

var wood: int = 0
var gold: int = 0
var stone: int = 0
var flour: int = 0
var wooden_planks: int = 0

func add_resource(resource_type: Enums.RESOURCE, val: int):
	match resource_type:
		Enums.RESOURCE.WOOD:
			wood += val
		Enums.RESOURCE.GOLD:
			gold += val
		Enums.RESOURCE.STONE:
			stone += val
		Enums.RESOURCE.FLOUR:
			flour += val 
		Enums.RESOURCE.WOODEN_PLANKS:
			wooden_planks += val
			
func set_resource(resource_type: Enums.RESOURCE, val: int):
	match resource_type:
		Enums.RESOURCE.WOOD:
			wood = val
		Enums.RESOURCE.GOLD:
			gold = val
		Enums.RESOURCE.STONE:
			stone = val
		Enums.RESOURCE.FLOUR:
			flour = val 
		Enums.RESOURCE.WOODEN_PLANKS:
			wooden_planks = val
		Enums.RESOURCE.NOT_SET:
			print("resource not set passed to set_resource")

func merge_resource_objects(external_resource: fh_resources, add: bool):
	var multiplier = 1
	if !add:
		multiplier = -1
		
	add_resource(Enums.RESOURCE.WOOD, external_resource.wood * multiplier)
	add_resource(Enums.RESOURCE.GOLD, external_resource.gold * multiplier)
	add_resource(Enums.RESOURCE.STONE, external_resource.stone * multiplier)
	add_resource(Enums.RESOURCE.FLOUR, external_resource.flour * multiplier)
	add_resource(Enums.RESOURCE.WOODEN_PLANKS, external_resource.wooden_planks * multiplier)

func get_resource_value(resource_type: Enums.RESOURCE):
	match resource_type:
		Enums.RESOURCE.WOOD:
			return wood
		Enums.RESOURCE.GOLD:
			return gold
		Enums.RESOURCE.STONE:
			return stone
		Enums.RESOURCE.FLOUR:
			return flour 
		Enums.RESOURCE.WOODEN_PLANKS:
			return wooden_planks

# at the moment, warehouse specific
func space_left(resource_type: Enums.RESOURCE) -> int:
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
	
	if piles < MAX_PILES:
		return (MAX_PILES - piles) * MAX_PILE_AMOUNT
	else:
		var res_val = get_resource_value(resource_type)
		var rem = res_val % MAX_PILE_AMOUNT
		return rem
	
