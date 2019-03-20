tool
extends GraphEdit

# number of nodes
onready var nb_nodes = 0
onready var context_menu = $PopupMenu
onready var graphnode_selected = null
onready var just_clicked_graphnode = false

var MultiOutputGraphNode = preload("res://addons/tree-tools/scenes/nodes/globals/multi_output_node.gd")

signal graphnode_selected(graphnode)
signal graphnode_unselected(graphnode)

func _ready():
	init()

func raise_clear_confirm():
	var clear_popup = $clear_confirmation_popup
	clear_popup.popup_centered()


# remove all nodes in editor
func clear():
	for ndel in get_children():
		if ndel is GraphNode:
			remove_child(ndel)

func init():
	set_right_disconnects(true)
	
	#add start node to the scene
	var startnode = _add_node("start")
	startnode.get_node("name").set_text("start")
	startnode.set_offset(Vector2(get_viewport_rect().size.x/2 - startnode.rect_size.x/2
		,get_viewport_rect().size.y/2 - startnode.rect_size.y/2))
	printt("STARTNODE", startnode.get_offset())

func _on_editor_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			BUTTON_RIGHT:
				context_menu.set_position(get_global_mouse_position())
				context_menu.popup()
			BUTTON_LEFT:
				if just_clicked_graphnode:
					# Don't take this click into account: that was a click on a graphnode
					# and that was managed in _on_graphnode_selected()
					just_clicked_graphnode = false
					return
				else:
					# we take this click into account: that was a left click out of a graphnode.
					if graphnode_selected == null:
						return
					else:
						graphnode_selected.unselect()
				
func set_children_graphnodes(list_graphnodes):
	for gn in list_graphnodes:
		add_child(gn)
		
func get_children_graphnodes():
	var list_graphnodes = []
	for gn in get_children():
		if gn is GraphNode:
			list_graphnodes.append(gn)
	return list_graphnodes

func get_graphnode_selected_in_tree():
	for c in get_children_graphnodes():
		if c is GraphNode && c.selected_:
			return c
	return null

func _on_editor_connection_request(from, from_slot, to, to_slot):
	var from_node = self.get_node(from)
	# This block of code allows use to define a slot type that is limited to 1 connection
	if from_node.get_slot_type_right(from_slot) == 1:
		for x in self.get_connection_list():
			if x["from"] == from and x["from_port"] == from_slot:
				self.disconnect_node(from, from_slot, x["to"], x["to_port"])
	self.connect_node(from, from_slot, to, to_slot)

func _on_editor_disconnection_request( from, from_slot, to, to_slot ):
	self.disconnect_node(from, from_slot, to, to_slot)

func _add_node(type):
	var node = load(ProjectSettings.get_setting("dialogtreetools/nodes_path") + type + ".tscn").instance()
	#var offset = Vector2(hscroll.get_val(), vscroll.get_val())
	var offset = Vector2(get_viewport_rect().size.x/2 - node.rect_size.x/2 + scroll_offset.x, 
		get_viewport_rect().size.y/2 - node.rect_size.y/2 + scroll_offset.y)
	nb_nodes += 1
	node.name = "node" + str(nb_nodes)
	set_signals_connections(node)
	add_child(node)
	node.set_offset(offset)
	return node

func set_signals_connections(graphnode):
	graphnode.connect("graphnode_selected", self, "_on_graphnode_selected")
	graphnode.connect("graphnode_unselected", self, "_on_graphnode_unselected")

func _on_add_button_pressed():
	context_menu.set_position(get_global_mouse_position())
	context_menu.popup()

func _on_graphnode_selected(graphnode):
	graphnode_selected = graphnode
	just_clicked_graphnode = true
	emit_signal("graphnode_selected", graphnode_selected)

func _on_graphnode_unselected(graphnode):
	emit_signal("graphnode_unselected", graphnode_selected)

#############
############# OPTION
#####################

func _on_option_block_instanced(block):
	printt("OPTION BLOCK INSTANCED", block, block.get_block_id())
	if graphnode_selected:
		graphnode_selected.add_option(block.get_block_name(), block.get_block_id())

func _on_option_block_removed(block_id):
	printt("OPTION BLOCK REMOVED", block_id)
	graphnode_selected.remove_option(block_id)

func _on_option_block_updated(block_id, new_name):
	printt("OPTION BLOCK UPDATED", block_id, new_name)
	graphnode_selected.update_option(block_id, new_name)
