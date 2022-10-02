extends Object
class_name fh_resources

var wood: int = 0
var gold: int = 0
var stone: int = 0
var flour: int = 0

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
