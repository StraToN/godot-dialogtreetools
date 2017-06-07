tool
extends Node


#var nodes_list = [] setget set_nodes_list,get_nodes_list
const TreeNodeResource = preload("res://addons/tree-tools/TreeNode/TreeNodeResource.gd")
var json setget set_json,get_json
export(Resource) var resource setget set_resource,get_resource


##################
# Here go all tree parsing functions !

func execute():
	pass

##################

func set_json(j):
	json = j
	
func get_json():
	return json

func set_resource(r):
	resource = r

func get_resource():
	return resource

