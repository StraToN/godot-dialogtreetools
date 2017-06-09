tool
extends "res://addons/tree-tools/Nodes/Globals/dialognode.gd"


func _init():
	self.type = "startnode"

##############

func save_data(nodes_list):
	nodes_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"name": get_node("vbox/name").get_text()
	})

func load_data(data):
	set_id( data["id"])
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	get_node("vbox/name").set_text(data["name"])

func export_data(file, connections, labels):
	var next = ""
	var name = get_node("vbox/name").get_text().percent_encode()
	for c in connections:
		next = c["to"]
	labels[name] = next
