
extends Control

var editor
var hscroll
var vscroll
var currentSaveFile = null



func _on_menu_item(id):
	if id == 0:
		# NEW
		print("new dialog...")
	elif id == 1:
		# LOAD
		if not get_node("save_dialog").is_hidden():
			get_node("save_dialog").hide()
		get_node("load_dialog").show()
	elif id == 2:
		# SAVE
		if currentSaveFile != null:
			_save_data(currentSaveFile)
		else:
			if not get_node("load_dialog").is_hidden():
				get_node("load_dialog").hide()
			get_node("save_dialog").show()
	elif id == 3:
		#SAVE AS
		if not get_node("load_dialog").is_hidden():
			get_node("load_dialog").hide()
		get_node("save_dialog").show()
	elif id == 4:
		# QUIT
		get_tree().quit()


func _ready():
	OS.set_low_processor_usage_mode(true)
	
	editor = get_node("editor")
	editor.set_right_disconnects(true)	# autoriser les déconnexions
	
	for c in editor.get_children():
		if not c extends GraphNode:
			hscroll = c.get_node("_h_scroll")
			vscroll = c.get_node("_v_scroll")
	
	var file_menu = get_node("toppanel/toolbar/Button").get_popup()
	file_menu.connect("item_pressed", self, "_on_menu_item")
	file_menu.add_item("New dialog") 	#0
	file_menu.add_item("Load")			#1
	file_menu.add_item("Save")			#2
	file_menu.add_item("Save as...")	#3
	file_menu.add_separator()			
	file_menu.add_item("Quit")			#4
	
	var save = get_node("save_dialog")
	save.set_access(save.ACCESS_FILESYSTEM)
	save.set_mode(save.MODE_SAVE_FILE)
	save.add_filter("*.json;JavaScript Object Notation")
	
	var load_ = get_node("load_dialog")
	load_.set_access(save.ACCESS_FILESYSTEM)
	load_.set_mode(save.MODE_OPEN_FILE)
	load_.add_filter("*.json;JavaScript Object Notation")
	
	#add start node
	_add_node("startnode").get_node("vbox/name").set_text("start")


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
	
	# insert nodes in editor
	var list_nodes_editor = editor.get_children()
	for ndel in list_nodes_editor:
		if ndel extends GraphNode:
			editor.remove_child(ndel)
	
	for n in jsonData["nodes"]:
		var new_node = _add_node(n["type"])
		new_node.load_data(n)
		
		# apply connections
		for c in jsonData["connections"]:
			editor.connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	


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
	print(type)
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

