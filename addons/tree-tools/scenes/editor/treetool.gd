tool
extends PanelContainer

const DialogNode = preload("res://addons/tree-tools/scenes/nodes/globals/node.gd")

var list_groups = []
onready var editor = $HSplitContainer/editor

func _ready():
	$save_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$save_dialog.set_mode($save_dialog.MODE_SAVE_FILE)
	$save_dialog.add_filter("*.json;JavaScript Object Notation")
	
	$load_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$load_dialog.set_mode($save_dialog.MODE_OPEN_FILE)
	$load_dialog.add_filter("*.json;JavaScript Object Notation")
	
# Helper function to clear the GraphEdit
func clear():
	if editor != null:
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
			debug_graphedit()
		
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
	if not get_node("save_dialog").visible:
		get_node("save_dialog").hide()
	get_node("load_dialog").popup_centered()


func _on_export_button_pressed():
	if not get_node("load_dialog").visible:
		get_node("load_dialog").hide()
	get_node("save_dialog").popup_centered()

func debug_graphedit():
	for i in editor.get_children():
		if (i is GraphNode):
			print(i.get_name())

func _on_editor_graphnode_selected(graphnode):
	var dict = {}
	$HSplitContainer/node_editor.show_data_for_graphnode(graphnode, dict)


func _on_editor_graphnode_unselected(graphnode):
	$HSplitContainer/node_editor.hide_editor()


func _on_node_editor_editor_instanced(editor_instance):
	# Connect node_editor events to GraphEdit
	if editor_instance.get("is_multi_output"):
		editor_instance.connect("block_instanced", $HSplitContainer/editor, "_on_option_block_instanced")
		editor_instance.connect("block_removed", $HSplitContainer/editor, "_on_option_block_removed")
		editor_instance.connect("block_updated", $HSplitContainer/editor, "_on_option_block_updated")

