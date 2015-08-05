extends GraphNode

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": "script",
		"name": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"label": get_node("vbox/name").get_text()
	})

func load_data(data):
	get_node("vbox/name").set_text(data["label"])

func export_data(file, connections, labels):
	var label = get_node("vbox/name").get_text().percent_encode()
	file.store_line("func " + get_name() + "(c):")
	file.store_line("\tself.call(labels[\"" + label + "\"], c)")
