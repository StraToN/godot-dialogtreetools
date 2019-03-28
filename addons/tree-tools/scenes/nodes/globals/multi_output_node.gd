tool
extends "res://addons/tree-tools/scenes/nodes/globals/node.gd"

func add_option(text):
	var label = Label.new()
	label.text = text
	label.align = Label.ALIGN_RIGHT
	label.clip_text = true
	add_child(label)
	
	for i in range(1, get_child_count()):
		.set_slot(i, false, 0, Color.white, true, 0, Color.white)

func remove_option(position):
	remove_child(get_child(position))
	
func remove_children():
	for c in get_children():
		remove_child(c)
	var label = Label.new()
	add_child(label)

func update_data(array_blocks_content):
	remove_children()
	for block_data_dict in array_blocks_content:
#		printt(block_data_dict)
		var choice_dialog = block_data_dict["choice_dialog"]
#		var repeat = block_data_dict["repeat"]
#		var not_said = block_data_dict["not_said"]
#		var condition = block_data_dict["condition"]
		add_option(choice_dialog)