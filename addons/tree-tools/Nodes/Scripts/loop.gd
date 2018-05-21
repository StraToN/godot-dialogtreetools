tool
extends "res://addons/tree-tools/Nodes/Globals/node.gd"

onready var time_loop = $VBoxContainer/hbox/time_loop

func _init():
	self.type = "loop"

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"time_loop": time_loop.get_text().percent_encode()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	time_loop.set_text(data["time_loop"])
