tool
extends "res://addons/tree-tools/Nodes/Globals/dialognode.gd"

var nodes_variables = []

func _init():
	self.type = "dialog_setvar"
	self.block_scene = "res://addons/tree-tools/Nodes/SubNodes/dialog_setvar_block.tscn"
	self.new_block_adds_left_slot = false
	self.new_block_adds_right_slot = false

func _ready():
	add_new_block()
	move_child(get_node("slot"), 1)

func load_data(data):
	set_id( data["id"] )
	set_offset( Vector2(data["x"], data["y"]))
	set_type( data["type"] )

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
