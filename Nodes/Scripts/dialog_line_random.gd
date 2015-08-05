extends GraphNode

func _ready():
	pass

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": "dialog_random",
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"lines": get_node("vbox_main_container/vbox_line/vbox_block/lines").get_text(),
		"anim": get_node("vbox_main_container/vbox_line/vbox_block/anim").get_text()
	})

func load_data(data):
	get_node("vbox_main_container/vbox_line/vbox_block/lines").set_text(data["lines"])
	get_node("vbox_main_container/vbox_line/vbox_block/anim").set_text(data["anim"])

func export_data(file, connections, labels):
	file.store_line("func " + get_name() + "(c):")
	var statement = get_node("vbox/statement").get_text()
	if statement == "":
		statement = "true"
	var branch_true = ""
	var branch_false = ""
	for conn in connections:
		if conn["from_port"] == 1:
			branch_true = conn["to"]
		if conn["from_port"] == 2:
			branch_false = conn["to"]
	file.store_line("\tif " + statement + ":")
	if branch_true != "":
		file.store_line("\t\t" + branch_true + "(c)")
	else:
		file.store_line("\t\tpass")
	if branch_false != "":
		file.store_line("\telse:")
		file.store_line("\t\t" + branch_false + "(c)")
