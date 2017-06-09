tool
extends "res://addons/tree-tools/Nodes/Globals/dialognode.gd"

var groupName = ""


func _init():
	self.type = "dialog_grouplabel"
	pass

func _ready():
	get_node("vbox/groupname").connect("text_changed", self, "_on_groupname_update")
	pass


func get_group_name():
	return groupName


func _on_close_request():
	queue_free()

func _on_groupname_update( text ):
	groupName = text
	pass # replace with function body



func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"groupname": get_node("vbox/groupname").get_text().percent_encode()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	get_node("vbox/groupname").set_text(data["groupname"])
	groupName = data["groupname"]
	

