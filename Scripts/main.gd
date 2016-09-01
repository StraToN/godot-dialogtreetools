tool
extends Control


const DialogNode = preload("../Nodes/Globals/dialognode.gd")
onready var editor = get_node("editor")
var hscroll
var vscroll
var currentSaveFile = null

var list_groups = []


func _ready():
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
	get_viewport().connect("size_changed", self, "_on_resized")
	

func _save_data(path):
	currentSaveFile = path
	var nodes_list = []
	
	# on cherche uniquement les nodes racines
	for gn in editor.get_children():
		if gn extends GraphNode:
			gn.save_data(nodes_list)
	
	var data = {
		"connections": editor.get_connection_list(),
		"nodes": nodes_list
		}
		
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(data.to_json())
	file.close()


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
	
	# remove all nodes in editor
	var list_nodes_editor = editor.get_children()
	for ndel in list_nodes_editor:
		if ndel extends GraphNode:
			editor.remove_child(ndel)
	# add new nodes
	for n in jsonData["nodes"]:
		var new_node = get_node("editor")._add_node(n["type"])
		print("New node: ")
		print(n)
		new_node.load_data(n)
		
	# apply connections
	for c in jsonData["connections"]:
		editor.connect_node(c["from"], c["from_port"], c["to"], c["to_port"])


func make_groups_list():
	list_groups = []
	for gn in editor.get_children():
		if gn extends DialogNode and gn.get_type() == "dialog_grouplabel":
			list_groups.append(gn.get_group_name())

func _on_resized():
	# set the size of the top panel and GraphEdit to the same as the frame on resize
	var vpSize = get_tree().get_root().get_rect().size
	get_node("editor").set_size( vpSize )

func _on_import_button_pressed():
	if not get_node("save_dialog").is_hidden():
		get_node("save_dialog").hide()
	get_node("load_dialog").popup_centered()


func _on_export_button_pressed():
	if not get_node("load_dialog").is_hidden():
		get_node("load_dialog").hide()
	get_node("save_dialog").popup_centered()
