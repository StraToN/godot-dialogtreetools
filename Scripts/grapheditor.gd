
extends GraphEdit


func _ready():
	connect("input_event", self, "input_event", [])

func input_event(ev):
	if (ev.is_pressed() and ev.type==InputEvent.MOUSE_BUTTON):
		print("pressed")
	elif (not ev.is_pressed() and ev.type==InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_RIGHT):
		print("released")

func _on_editor_connection_request(from, from_slot, to, to_slot):
	var from_node = self.get_node(from)
	if from_node.get_slot_type_right(from_slot) == 0:
		for x in self.get_connection_list():
			if x["from"] == from and x["from_port"] == from_slot:
				self.disconnect_node(from, from_slot, x["to"], x["to_port"])
	
	self.connect_node(from, from_slot, to, to_slot)
	pass


func _on_editor_disconnection_request( from, from_slot, to, to_slot ):
	self.disconnect_node(from, from_slot, to, to_slot)
	pass