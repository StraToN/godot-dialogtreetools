
extends GraphEdit

# number of nodes
onready var nb_nodes = 0
onready var context_menu = get_node("PopupMenu")
var hscroll
var vscroll

func _ready():
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
				context_menu.set_pos(ev.pos)
				context_menu.popup()

func _on_editor_connection_request(from, from_slot, to, to_slot):
	var from_node = self.get_node(from)
	if from_node.get_slot_type_right(from_slot) == 0:
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