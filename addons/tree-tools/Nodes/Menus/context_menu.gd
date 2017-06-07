tool
extends PopupMenu

export(NodePath) var editor_path = "Panel/editor"

func _ready():
	connect("item_pressed", self, "on_item_pressed")

func on_item_pressed(item_id):
	print(item_id)
	var node_type
	if (item_id) == 0:
		node_type = "startnode"
	elif (item_id == 1):
		node_type = "dialog_line"
	elif (item_id == 2):
		node_type = "dialog_line_random"
	elif (item_id == 3):
		node_type = "dialog_option"
	elif (item_id == 4):
		node_type = "dialog_setvar"
	elif (item_id == 5):
		node_type = "dialog_grouplabel"
	elif (item_id == 6):
		node_type = "dialog_condition"
	elif (item_id == 7):
		node_type = "dialog_jump"
	elif (item_id == 8):
		node_type = "dialog_loop"
	get_node(editor_path)._add_node(node_type)