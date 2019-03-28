tool
extends "res://addons/tree-tools/scenes/nodes/globals/node.gd"

const default_graphnode_title = "Dialog lines (%s)"
var number_lines = 0

func _ready():
	.set_graphnode_type("line")
	update_title()

func notify_block_instanced():
	number_lines += 1
	update_title()

func notify_block_removed():
	number_lines -= 1
	update_title()
	
func update_title():
	title = default_graphnode_title % str(number_lines)

func remove_children():
	for c in get_children():
		remove_child(c)

func update_data(array_blocks_content):
	remove_children()
	for block_data_dict in array_blocks_content:
#		printt(block_data_dict)
		var actor_id = block_data_dict["actor_id"]
		var dialog = block_data_dict["dialog"].left(25)
		var node = Label.new()
		node.clip_text = true
		node.text = "%s : %s" % [actor_id, dialog]
		add_child(node)
			