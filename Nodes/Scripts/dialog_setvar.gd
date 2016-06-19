extends "../Globals/dialognode.gd"

var nodes_variables = []

func _init():
	self.type = "dialog_setvar"
	pass

func _ready():
	add_new_block("res://Nodes/SubNodes/dialog_setvar_block.tscn")
	pass
	
func _on_remove_pressed(node):
	get_node("vbox_main_container").remove_child(node)
	nodes_variables.remove( nodes_variables.find(node) )
	nbVariables -= 1
	
	if nbVariables == 1:
		nodes_variables[0].hide_rembutton()
	
	var resize = get_minimum_size()
	set_size( Vector2(resize.x, 0 ) )


func _on_close_request():
	queue_free()


func save_data(node_list):
	node_list.push_back({
		"type": self.type,
		"id": get_name(),
		"x": get_offset().x,
		"y": get_offset().y,
		"statement": get_node("vbox/statement").get_text().percent_encode()
	})

func load_data(data):
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))
	get_node("vbox/statement").set_text(data["statement"])

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
