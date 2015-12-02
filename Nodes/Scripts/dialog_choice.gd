extends "../Globals/dialognode.gd"

func _init():
	self.type = "dialog_choice"
	pass

func _ready():
	pass

func _on_close_request():
	queue_free()

func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	pass

func export_data(file, connections, labels):
	file.store_line("func " + get_name() + "(c):")
	for conn in connections:
		file.store_line("\t" + conn["to"] + "(c)")
