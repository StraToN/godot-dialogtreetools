extends GraphNode

var nbVariables = 0
var nodes_variables = []

func _ready():
	_add_var()
	pass

func _add_var():
	var node = load("res://Nodes/SubNodes/dialog_setvar_block.scn").instance()
	node.set_id(nbVariables)
	
	node.add_rembutton(self)
	if nbVariables+1 <= 1:
		node.hide_rembutton()
	
	node.add_addbutton(self)
	
	# add new line block to the main container
	get_node("vbox_main_container").add_child(node)
	nodes_variables.append(node)
	nbVariables += 1
	
	# at least 2 variables, add remove button to first variable so it can be deleted
	if nbVariables > 1:
		nodes_variables[0].show_rembutton()


func _on_add_pressed():
	_add_var()
	pass
	
func _on_remove_pressed(node):
	get_node("vbox_main_container").remove_child(node)
	nodes_variables.remove( nodes_variables.find(node) )
	nbVariables -= 1
	
	if nbVariables == 1:
		nodes_variables[0].hide_rembutton()
	
	var resize = get_node("vbox_main_container").get_size()
	set_size( Vector2(resize.x+32, resize.y ) )


func _on_close_request():
	queue_free()


func save_data(node_list):
	node_list.push_back({
		"type": "dialog_setvar",
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
