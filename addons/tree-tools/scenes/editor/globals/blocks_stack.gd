tool
extends "res://addons/tree-tools/scenes/editor/globals/editor.gd"

export(PackedScene) var block_scene setget set_block_scene # PackedScene containing the block that can be added and removed from the stack
var blocks_instances = []
var max_id = 0

signal block_instanced(block)
signal block_removed(block_id)
signal block_updated(block)

func set_block_scene(scene):
	block_scene = scene

func instance_block(after_block):
	if block_scene == null:
		return
	
	var block = block_scene.instance()
	max_id += 1
	add_child(block)
	block.set_block_id(max_id)
	
	if after_block != null:
		var position = after_block.get_position_in_parent() + 1
		move_child(block, position)
		
	blocks_instances.append(block)
	connect_buttons(block)
	
	if get_child_count() > 1:
		get_child(0).show_remove_button()
	else:
		get_child(0).hide_remove_button()
	emit_signal("block_instanced", block)


func remove_block(block):
	var id = block.get_block_id()
	blocks_instances.erase(block)
	remove_child(block)
	
	if get_child_count() == 1:
		get_child(0).hide_remove_button()
	emit_signal("block_removed", id)

func connect_buttons(block):
	block.get_node(block.button_add).connect("pressed", self, "_on_button_add_pressed", [block])
	block.get_node(block.button_remove).connect("pressed", self, "_on_button_remove_pressed", [block])
	
func _on_button_add_pressed(block):
	instance_block(block)

func _on_button_remove_pressed(block):
	remove_block(block)

func notify_name_updated(id, new_text):
	emit_signal("block_updated", id, new_text)