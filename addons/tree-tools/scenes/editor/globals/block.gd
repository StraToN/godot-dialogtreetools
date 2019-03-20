extends Node
class_name block

var id setget set_block_id, get_block_id
export(NodePath) var label_id
export(NodePath) var button_add
export(NodePath) var button_remove
export(NodePath) var option_element

signal block_name_updated(id, new_text)

func set_block_id(bid):
	id = bid
	get_node(label_id).text = str(id)

func get_block_id():
	return id

func get_block_name():
	return get_node(option_element).text

func hide_remove_button():
	get_node(button_remove).hide()

func show_remove_button():
	get_node(button_remove).show()

func _on_text_text_changed(new_text):
	get_parent().notify_name_updated(id, new_text)
