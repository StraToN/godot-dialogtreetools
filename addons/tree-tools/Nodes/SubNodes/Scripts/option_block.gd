tool
extends "res://addons/tree-tools/Nodes/Globals/node_block.gd"

func _ready():
	pass

func get_data():
	var id = int($hbox/id.get_text())
	var option = $vbox_line/box_say/HBoxContainer/text.get_text()
	var repeat = $vbox_params/repeat.is_pressed()
	var not_said = $vbox_params/not_said.is_pressed()
	var condition = $vbox_params/condition.get_text()
	var data = {}
	data["id"] = id
	data["collapsed"] = is_collapsed()
	data["option"] = option
	data["repeat"] = repeat
	data["not_said"] = not_said
	data["condition"] = condition
	return data

func set_data(data):
	$hbox/id.set_text(str(data["id"]))
	if (data["collapsed"]):
		_on_collapse_block_pressed()
	$vbox_line/box_say/HBoxContainer/text.set_text(data["option"])
	$vbox_params/repeat.set_pressed(data["repeat"])
	$vbox_params/not_said.set_pressed(data["not_said"])
	$vbox_params/condition.set_text(data["condition"])