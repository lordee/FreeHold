extends Node
class_name fh_entity

@export var team_no: int = 0
@export var entity_type: Enums.ENTITY = Enums.ENTITY.NOT_SET
var entity_category: Enums.ENTITY_CATEGORY:
	get:
		return game.data.items[entity_type].entity_category
var player_owner: fh_player = null
@onready var entry: Node3D = get_node_or_null("entry")
@onready var gather_area: StaticBody3D = get_node_or_null("gather_area")
@onready var game: fh_game = get_node_or_null("/root/game")
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
