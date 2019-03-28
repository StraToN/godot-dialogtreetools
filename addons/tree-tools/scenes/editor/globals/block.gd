extends Node
class_name block

var id setget set_block_id, get_block_id
export(NodePath) var label_id
export(NodePath) var button_add
export(NodePath) var button_remove
export(NodePath) var option_element
export(Array) var elements_to_save

signal block_name_updated(id, new_text)

func _ready():
	for np in elements_to_save:
		var element_to_connect = get_node(np)
		if element_to_connect is LineEdit:
			element_to_connect.connect("text_changed", self, "_on_data_changed")
		if element_to_connect is TextEdit:
			element_to_connect.connect("text_changed", self, "_on_data_changed", [null])
		if element_to_connect is CheckBox:
			element_to_connect.connect("toggled", self, "_on_data_changed", [null])

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

func _on_data_changed(new_value):
	get_parent().notify_content_updated()

func get_data_dictionary() -> Dictionary:
	var dict = {}
	for element in elements_to_save:
		var node = get_node(element)
		if node is LineEdit || node is TextEdit:
			dict[element.get_name(element.get_name_count()-1)] = node.text
		elif node is CheckBox:
			dict[element.get_name(element.get_name_count()-1)] = node.pressed
	return dict