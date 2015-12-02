extends "../Globals/dialognode.gd"

func _init():
	self.type = "dialog_option"
	pass

func _ready():
	get_node("vbox/vbox_line").parentPanel = self
	pass

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"lines": get_node("vbox/vbox_line/vbox_block/lines").get_text().percent_encode(),
		"anim": get_node("vbox/vbox_line/vbox_block/anim").get_text().percent_encode(),
		"not_said": get_node("vbox/not_said").is_pressed(),
		"repeat": get_node("vbox/repeat").is_pressed(),
		"condition": get_node("vbox/condition").get_text().percent_encode(),
		"hidden": get_node("vbox/vbox_line").is_hidden_state()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	get_node("vbox/vbox_line/vbox_block/lines").set_text(data["lines"])
	get_node("vbox/vbox_line/vbox_block/anim").set_text(data["anim"])
	get_node("vbox/not_said").set_pressed(data["not_said"])
	if data.has("repeat"):
		get_node("vbox/repeat").set_pressed(data["repeat"])
	get_node("vbox/condition").set_text(data["condition"])
	if data.has("hidden"):
		if data["hidden"] == true:
			get_node("vbox/vbox_line")._on_btn_hide_pressed()
	

func export_data(file, connections, labels):
	file.store_line("func " + get_name() + "(c):")
	var title = get_node("vbox/title").get_text().percent_encode()
	var condition = get_node("vbox/condition").get_text()
	var next = ""
	for conn in connections:
		next = conn["to"]
	if condition != "":
		file.store_line("\tif " + condition + ":")
		file.store_string("\t")
	file.store_line("\tadd_option(\"" + title + "\".percent_decode(), \"" + next + "\")")
