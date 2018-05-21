tool
extends PanelContainer

var EDITORPLUGIN

const DialogNode = preload("../Nodes/Globals/node.gd")
onready var editor = $split_container/editor
var currentSaveFile = null

var list_groups = []


func _ready():
	$save_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$save_dialog.set_mode($save_dialog.MODE_SAVE_FILE)
	$save_dialog.add_filter("*.json;JavaScript Object Notation")
	
	$load_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$load_dialog.set_mode($save_dialog.MODE_OPEN_FILE)
	$load_dialog.add_filter("*.json;JavaScript Object Notation")


# returns data in a json string
func get_json_string():
	return get_dictionary().to_json()
	
	
# returns data in a dictionary
func get_dictionary():
	var nodes_list = []
	print("Get Dictionary " + str(editor)) 
	for gn in editor.get_children():
		if gn is GraphNode:
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
	var jsonData = {}
	jsonData.parse_json(jsonString)
	load_from_json(jsonData)

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

# Load graph data from dictionary
func load_from_dict(dict):
	print_stack()
	
	# add new nodes
	if dict.has("nodes"):
		for n in dict["nodes"]:
			var new_node = editor._add_node(n["type"])
	#			printt("New node: ", n)
			new_node.load_data(n)
			
			debug_grapedit()
		
	# apply connections
#		printt("LOADING CONNECTIONS = ", dict["connections"])
	if dict.has("connections"):
		for c in dict["connections"]:
	#			printt("connect: ", c["from"], c["to"])
			editor.connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	
	print("LOADING FROM DICT DONE")


func is_jsondata_valid(jsonDataString):
	var isValid = true
	if (jsonDataString == null):
		isValid = false
	else:
		var jsonData = {}
		jsonData.parse_json(jsonDataString)
#		print("JSONDATASTRING IS NOT NULL - OK")
		if (!jsonData.has("nodes") or !jsonData.has("connections")):
			isValid = false
	return isValid

func make_groups_list():
	list_groups = []
	for gn in editor.get_children():
		if gn is DialogNode and gn.get_type() == "dialog_grouplabel":
			list_groups.append(gn.get_group_name())
			

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

func debug_grapedit():
	for i in editor.get_children():
		if (i is GraphNode):
			print(i.get_name())