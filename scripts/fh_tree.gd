extends fh_entity_resource
class_name fh_tree # FIXME - x is fh_tree not working on raycast here, so we will use groups, godot 4 beta bug?

# state
var life_stage: Enums.LIFE_STAGE = Enums.LIFE_STAGE.MATURE

var _game_tick_age: int = 0
var game_tick_age: int:
	get:
		return _game_tick_age
	set(value):
		_game_tick_age = value
		
		if _game_tick_age >= (int(life_stage) + 1) * game.settings.game_tick_year:
			if int(life_stage) < int(Enums.LIFE_STAGE.MATURE):
				var new_stage = int(life_stage) + 1
				life_stage = Enums.LIFE_STAGE.keys()[new_stage]

# Called when the node enters the scene tree for the first time.
func _ready():
	body.add_to_group("fh_tree")
	resources.wood = 50
	entity_type = Enums.ENTITY.RESOURCE_TREE
	resource_type = Enums.RESOURCE.WOOD

func reproduce(force_reproduce: bool = false):
	if force_reproduce == false:
		if game_tick_age != 0 and game_tick_age % (game.settings.game_tick_year) == 0:
			var chance: int = randi() % 1 # 0 - 1
			if chance == 1:
				force_reproduce = true
	
	if force_reproduce == true:
		# choose an empty spot within 8 "tiles"
		var aabb: AABB = mesh.get_aabb()
		
		var sz: Vector3 = aabb.size
		var org: Vector3 = self.global_transform.origin
		
		# create box
		var shape: BoxShape3D = BoxShape3D.new()
		shape.size = sz
		var space = PhysicsServer3D.body_get_space(body.get_rid())
		var state = PhysicsServer3D.space_get_direct_state(space)
		var param = PhysicsShapeQueryParameters3D.new()
		param.shape_rid = shape.get_rid()
		param.global_transform = self.global_transform
		
		var empty_points: Array = Array()
		var elements = range(1, 8)
		for i in elements:
			var x: float = org.x + (sz.x / 2)
			for i2 in elements:
				var z: float = org.z + (sz.z / 2)
				
				var point_test: Vector3 = Vector3(x, org.y, z) # FIXME - terrain height changes etc...
				
				param.global_transform.origin = point_test
				var result: Array[Dictionary] = state.intersect_shape(param, 32)
				
				if len(result) == 0:
					empty_points.append(point_test)
		
		# create a sprout tree randomly
		var max_pos = len(empty_points) - 1
		var rand: int = randi() % max_pos
		
		game.entity_manager.spawn_entity(Enums.ENTITY.RESOURCE_TREE, empty_points[rand])
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
