tool
extends Node

export(Resource) var resource setget set_resource,get_resource
var resource_changed = false # if true, we need to update the GraphEdit with the resource content


# tree parsing variables
var root # root of the tree
var currents_list = [] # current elements of the tree (if > 1, currents probably are Option nodes)


##################
# Here go all tree parsing functions !

func advance_state():
	if (root == null):
		root = find_root()
		reinit_state()
	else:
		if currents_list.size() > 0:
			currents_list = get_nexts(currents_list[0])
#	print("CURRENT LIST = ")
#	print(currents_list)
	return currents_list

# Reinits the current state of the tree to the root
func reinit_state():
	currents_list = get_nexts(root)


func advance_state_option(n, option_block):
	currents_list = get_nexts_state_option(n, option_block)
	return currents_list


func get_nexts_state_option(n, option_block):
	var dict = resource.dict
	var nexts_list = []

	for connection in dict.connections:
		if connection.from == n && connection.from_port == option_block.id:
			var node = get_node_by_id(dict, connection.to)
			print("NEXT : ", node)
			nexts_list.append(node)
	return nexts_list


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
	var nexts_list = []
	
	for connection in dict.connections:
		if connection.from == n.id:
			var node = get_node_by_id(dict, connection.to)
#			print("NEXT : ", node)
			nexts_list.append(node)
	return nexts_list


	

func get_node_by_id(dict, id):
	for n in dict.nodes:
		if n.id == id:
			return n
	return null
	
##################

func set_resource(r):
	resource = r
	resource_changed = true

func get_resource():
	return resource