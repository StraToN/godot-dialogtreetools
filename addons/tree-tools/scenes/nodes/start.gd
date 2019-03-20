tool
extends "res://addons/tree-tools/scenes/nodes/globals/node.gd"

func _ready():
	.set_graphnode_type("start")

func save_data(nodes_list):
	nodes_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"name": $vbox/name.get_text()
	})

func load_data(data):
	set_offset( Vector2(data["x"], data["y"]))
	$vbox/name.set_text(data["name"])

func export_data(file, connections, labels):
	var next = ""
	var name_val = $vbox/name.get_text().percent_encode()
	for c in connections:
		next = c["to"]
	labels[name_val] = next

