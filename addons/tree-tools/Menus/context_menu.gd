tool
extends PopupMenu

func _ready():
	connect("index_pressed", self, "on_item_pressed")

func on_item_pressed(item_id):
	print(item_id)
	var node_type
	if (item_id) == 0:
		node_type = "startnode"
	elif (item_id == 1):
		node_type = "line"
	elif (item_id == 2):
		node_type = "line_random"
	elif (item_id == 3):
		node_type = "option"
	elif (item_id == 4):
		node_type = "setvar"
	elif (item_id == 5):
		node_type = "grouplabel"
	elif (item_id == 6):
		node_type = "condition"
	elif (item_id == 7):
		node_type = "jump"
	elif (item_id == 8):
		node_type = "loop"
	get_parent()._add_node(node_type)