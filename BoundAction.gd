extends Node

class_name BoundAction

var action_name: String
var key_name: String
var func_callable: Callable
var key_type: KeyType

func _init(action: String, key: String, func_call: Callable):
	action_name = action
	key_name = key
	func_callable = func_call
