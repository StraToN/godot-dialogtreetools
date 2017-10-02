tool
extends Control


const DialogNode = preload("../Nodes/Globals/dialognode.gd")
onready var editor = get_node("Panel/editor")
var hscroll
var vscroll
var currentSaveFile = null

var list_groups = []


func ready():
	OS.set_low_processor_usage_mode(true)
	
	for c in editor.get_children():
		if not c extends GraphNode:
			hscroll = c.get_node("_h_scroll")
			vscroll = c.get_node("_v_scroll")
		if not hscroll == null and not vscroll == null:
			break

	var save = get_node("save_dialog")
	save.set_access(save.ACCESS_FILESYSTEM)
	save.set_mode(save.MODE_SAVE_FILE)
	save.add_filter("*.json;JavaScript Object Notation")
	
	var load_ = get_node("load_dialog")
	load_.set_access(save.ACCESS_FILESYSTEM)
	load_.set_mode(save.MODE_OPEN_FILE)
	load_.add_filter("*.json;JavaScript Object Notation")
	
	# add signals to the frame
	#get_viewport().connect("size_changed", self, "_on_resized")
	#_on_resized()

# returns data in a json string
func get_json_string():
	return get_dictionary().to_json()
	
	
# returns data in a dictionary
func get_dictionary():
	var nodes_list = []
	for gn in editor.get_children():
		if gn extends GraphNode:
			gn.save_data(nodes_list)
	var data = {
		"connections": editor.get_connection_list(),
		"nodes": nodes_list
		}
#	print(data.to_json())
	return data

# Save a complete tree into a JSON file at given path
func _save_data(path):
	currentSaveFile = path
	var json_data = get_dictionary()
		
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(json_data.to_json())
	file.close()

# Load a complete tree from a JSON file at given path
func _load_data( path ):
	currentSaveFile = path
	
	# read file
	var file = File.new()
	file.open(path, file.READ)
	var jsonString = file.get_as_text().percent_decode()
	file.close()
	
	# parse json
	load_from_json(jsonString)

# Helper function to clear the GraphEdit
func clear():
	editor.clear()

# Load data from a JSON string (given in jsonData)
func load_from_json(jsonDataString):
	# remove all nodes in editor
	clear()
	
	if (is_jsondata_valid(jsonDataString)):
		var jsonData = {}
		jsonData.parse_json(jsonDataString)
		
		load_from_dict(jsonData)
	else:
		print("ERROR: invalid json string.")
		print(jsonDataString)

# Load graph data from dictionary
func load_from_dict(dict):
	# add new nodes
	for n in dict["nodes"]:
		var new_node = editor._add_node(n["type"])
#			printt("New node: ", n)
		new_node.load_data(n)
		
#		for i in editor.get_children():
#			if (i extends GraphNode):
#				print(i.get_name())
		
	# apply connections
#		printt("LOADING CONNECTIONS = ", dict["connections"])
	for c in dict["connections"]:
#			printt("connect: ", c["from"], c["to"])
		editor.connect_node(c["from"], c["from_port"], c["to"], c["to_port"])


func is_jsondata_valid(jsonDataString):
	var isValid = true
	if (jsonDataString == null):
		isValid = false
	else:
		var jsonData = {}
		jsonData.parse_json(jsonDataString)
		if (!jsonData.has("nodes") or !jsonData.has("connections")):
			print("ERROR: JSON dict doesn't contain required keys.")
			isValid = false
	return isValid

func make_groups_list():
	list_groups = []
	for gn in editor.get_children():
		if gn extends DialogNode and gn.get_type() == "dialog_grouplabel":
			list_groups.append(gn.get_group_name())
			

func set_state(state):
	pass
	
func get_state(state):
	pass
	
func clear_state():
	pass

func _on_resized():
	# set the size of the top panel and GraphEdit to the same as the frame on resize
	#var vpSize = get_tree().get_root().get_rect().size
	editor.set_size( get_rect().size )

func _on_import_button_pressed():
	if not get_node("save_dialog").is_hidden():
		get_node("save_dialog").hide()
	get_node("load_dialog").popup_centered()


func _on_export_button_pressed():
	if not get_node("load_dialog").is_hidden():
		get_node("load_dialog").hide()
	get_node("save_dialog").popup_centered()
