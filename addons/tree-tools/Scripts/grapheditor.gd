tool
extends GraphEdit

# number of nodes
onready var nb_nodes = 0
onready var context_menu = get_node("PopupMenu")
var hscroll
var vscroll

func _ready():
	init()


func raise_clear_confirm():
	var clear_popup = get_node("clear_confirmation_popup")
	clear_popup.popup_centered()


# remove all nodes in editor
func clear():
	for ndel in  get_children():
		if ndel extends GraphNode:
			remove_child(ndel)

func init():
	set_right_disconnects(true)
	
	for c in get_children():
		if not c extends GraphNode:
			hscroll = c.get_node("_h_scroll")
			vscroll = c.get_node("_v_scroll")
		if not hscroll == null and not vscroll == null:
			break
	
	add_child(context_menu)
	
	#add start node to the scene
	var startnode = _add_node("startnode")
	startnode.get_node("vbox/name").set_text("start")
	startnode.set_offset(startnode.get_offset() - Vector2(get_size().x,200))

func _input_event(ev):
	if (ev != null):
		if (ev.is_pressed() and ev.type==InputEvent.MOUSE_BUTTON):
			if (ev.button_index == 2):
				context_menu.set_pos(get_global_mouse_pos())
				context_menu.popup()

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
	var node = load("res://addons/tree-tools/Nodes/" + type + ".tscn").instance()
	var offset = Vector2(hscroll.get_val(), vscroll.get_val())
	nb_nodes += 1
	node.set_name("node" + str(nb_nodes))
	add_child(node)
	node.set_offset(offset + (get_size() - node.get_size()) / 2)
	return node

func set_children_graphnodes(list_graphnodes):
	for gn in list_graphnodes:
		add_child(gn)
		
func get_children_graphnodes():
	var list_graphnodes = []
	for gn in get_children():
		if gn extends GraphNode:
			list_graphnodes.append(gn)
	return list_graphnodes