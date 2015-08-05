
extends GraphNode

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass


func _on_close_request():
	queue_free()


func save_data(node_list):
	node_list.push_back({
		"type": "dialog_grouplabel",
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"name": get_node("vbox/groupname").get_text()
	})

func load_data(data):
	get_node("vbox/groupname").set_text(data["name"])