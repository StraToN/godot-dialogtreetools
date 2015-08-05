extends GraphNode

func _ready():
	pass

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": "choice",
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y
	})

func load_data(data):
	pass

func export_data(file, connections, labels):
	file.store_line("func " + get_name() + "(c):")
	for conn in connections:
		file.store_line("\t" + conn["to"] + "(c)")
