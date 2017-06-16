tool
extends Node


#var nodes_list = [] setget set_nodes_list,get_nodes_list
const TreeNodeResource = preload("res://addons/tree-tools/TreeNode/TreeNodeResource.gd")
var json setget set_json,get_json
export(Resource) var resource setget set_resource,get_resource
var external_path setget set_external_path,get_external_path

# tree parsing variables
var root # root of the tree
var currentsList = [] # current elements of the tree (if > 1, currents probably are Option nodes)


##################
# Here go all tree parsing functions !

func execute():
	if (root == null):
		root = find_root()
		currentsList = get_nexts(root)
	else:
		currentsList = get_nexts(currentsList[0])
#	print("CURRENT LIST = ")
#	print(currentsList)
	return currentsList

# Returns the root (startnode)
func find_root():
	var dict = resource.dict
	for n in dict.nodes:
		if n.type == "startnode":
			return n
	return null

# Returns the list of nodes following n
func get_nexts(n):
	var dict = resource.dict
	var nextsList = []
	
	for connection in dict.connections:
		if connection.from == n.id:
			var node = get_node_by_id(dict, connection.to)
#			print("NEXT : ", node)
			nextsList.append(node)
	return nextsList

func get_node_by_id(dict, id):
	for n in dict.nodes:
		if n.id == id:
			return n
	return null
	
##################

func set_json(j):
	json = j
	
func get_json():
	return json

func set_resource(r):
	resource = r

func get_resource():
	return resource

func set_external_path(ep):
	external_path = ep

func get_external_path():
	return external_path