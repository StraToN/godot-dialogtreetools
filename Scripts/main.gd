
extends Control

var editor
var file_menu
var hscroll
var vscroll

# member variables here, example:
# var a=2
# var b="textvar"

func _on_menu_item(id):
	if id == 0:
		print("new dialog...")
	elif id == 1:
		saveDialog()
	elif id == 2:
		get_tree().quit()


func _ready():
	OS.set_low_processor_usage_mode(true)
	
	editor = get_node("editor")
	editor.set_right_disconnects(true)	# autoriser les déconnexions
	
	for c in editor.get_children():
		if not c extends GraphNode:
			hscroll = c.get_node("_h_scroll")
			vscroll = c.get_node("_v_scroll")
	
	file_menu = get_node("toppanel/toolbar/Button").get_popup()
	file_menu.connect("item_pressed", self, "_on_menu_item")
	file_menu.add_item("New dialog")
	file_menu.add_item("Save")
	file_menu.add_separator()
	file_menu.add_item("Quit")
	
	_add_node("startnode").get_node("vbox/name").set_text("start")


func saveDialog():
	var nodes_list = []
	var connections_list = editor.get_connection_list()
	print(connections_list)
	
	# on cherche uniquement les nodes racines
	for gn in editor.get_children():
		if gn extends GraphNode:
			var inputCount = gn.get_connection_input_count()
			if inputCount == 0:
				print(gn)
				#nodes_list.append( inst2dict(gn) )
				gn.save_data()
	
	print(nodes_list)
				

func loadDialog():
	print("load...")

func _on_editor_connection_request(from, from_slot, to, to_slot):
	var from_node = editor.get_node(from)
	if from_node.get_slot_type_right(from_slot) == 0:
		for x in editor.get_connection_list():
			if x["from"] == from and x["from_port"] == from_slot:
				editor.disconnect_node(from, from_slot, x["to"], x["to_port"])
				
	editor.connect_node(from, from_slot, to, to_slot)
	pass


func _on_editor_disconnection_request( from, from_slot, to, to_slot ):
	editor.disconnect_node(from, from_slot, to, to_slot)
	pass
	
	
	
func _add_node(type):
	var node = load("res://Nodes/" + type + ".scn").instance()
	var offset = Vector2(hscroll.get_val(), vscroll.get_val())
	var i = 1
	while editor.get_node("node" + str(i)) != null:
		i += 1
	node.set_name("node" + str(i))
	editor.add_child(node)
	node.set_offset(offset + (editor.get_size() - node.get_size()) / 2)
	return node

func _on_resized():
	get_node("toppanel").set_size( Vector2(get_size().x, get_node("toppanel").get_size().y) )
	get_node("editor").set_size( Vector2(get_size().x, get_size().y) )
	pass # replace with function body



