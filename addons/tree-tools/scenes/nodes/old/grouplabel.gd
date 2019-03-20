tool
extends "res://addons/tree-tools/scenes/globals/node.gd"

onready var group_name = $vbox/groupname
var groupName = ""


func _init():
	self.type = "grouplabel"

func _ready():
	group_name.connect("text_changed", self, "_on_groupname_update")


func get_group_name():
	return groupName


func _on_close_request():
	queue_free()

func _on_groupname_update( text ):
	groupName = text


func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"groupname": group_name.get_text().percent_encode()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	group_name.set_text(data["groupname"])
	groupName = data["groupname"]
	

