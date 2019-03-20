tool
extends "res://addons/tree-tools/scenes/nodes/globals/node.gd"

func add_option(text, position):
	var label = Label.new()
	label.text = text
	label.align = Label.ALIGN_RIGHT
	add_child(label)
	move_child(label, position)
	
	for i in range(1, get_child_count()):
		.set_slot(i, false, 0, Color.white, true, 0, Color.white)

func remove_option(position):
	remove_child(get_child(position))
	
func update_option(block_id, new_name):
	get_child(block_id).text = new_name
	