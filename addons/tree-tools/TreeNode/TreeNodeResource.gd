tool
extends Resource


#var nodes_list = [] setget set_nodes_list,get_nodes_list
export(Dictionary) var dict = {"connections":[], "nodes":[{"id":"node1", "x":0, "y":0, "type":"startnode", "name":"start"}]} setget set_dictionary, get_dictionary


###################

func set_dictionary(dictionary):
	dict = dictionary
	
func get_dictionary():
	return dict

