tool
extends PopupMenu

func _ready():
	connect("index_pressed", self, "on_item_pressed")

func on_item_pressed(item_id):
	print(item_id)
	var node_type
	if (item_id) == 0:
		node_type = "line"
	elif (item_id == 1):
		node_type = "option"
	get_parent()._add_node(node_type)