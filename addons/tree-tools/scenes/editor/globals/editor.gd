tool
extends Node

export(String, "line", "option") var type setget set_type
export(bool) var is_multi_output = false
	
func load_data(json):
	print("BASE EDITOR.LOAD_DATA()")

func set_type(t):
	type = t