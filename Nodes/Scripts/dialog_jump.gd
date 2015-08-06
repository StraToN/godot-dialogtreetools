extends GraphNode

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": "dialog_jump",
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"jump_to": get_node("vbox/jump_to").get_text().percent_encode()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	get_node("vbox/jump_to").set_text(data["jump_to"])

func export_data(file, connections, labels):
	var label = get_node("vbox/jump_to").get_text().percent_encode()
	file.store_line("func " + get_name() + "(c):")
	file.store_line("\tself.call(labels[\"" + label + "\"], c)")
