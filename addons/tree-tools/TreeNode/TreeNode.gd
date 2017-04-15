tool
extends Node

#var nodes_list = [] setget set_nodes_list,get_nodes_list
export(String) var json setget set_json, get_json

func _ready():
	json = {"connections":[], "nodes":[]}

func set_json(json_content):
	json = json_content
	
func get_json():
	return json
