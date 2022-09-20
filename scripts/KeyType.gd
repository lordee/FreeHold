extends Node


class_name KeyType

var ENUMS = load("res://scripts/Enums.gd")

var button_type: Enums.BUTTON_TYPE
var button_value: int

func _init(type: Enums.BUTTON_TYPE, value: int):
	button_type = type
	button_value = value
