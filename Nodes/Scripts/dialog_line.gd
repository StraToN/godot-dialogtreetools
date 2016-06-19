extends "../Globals/dialognode.gd"

var nbBlockLines = 0
var nodes_lines = []	# list of line blocks

func _init():
	self.type = "dialog_line"
	self.block_scene = "res://Nodes/SubNodes/dialog_line_block.tscn"
	self.new_block_adds_left_slot = false
	self.new_block_adds_right_slot = false

func _ready():
	add_new_block()


func save_data(node_list):
	var nodeDict = {
			"type": self.type,
			"id": get_name(),
			"x": get_offset().x,
			"y": get_offset().y
			}
	for i in range(0, nbBlockLines):
		var block = nodes_lines[i]
		nodeDict["lines"+str(block.get_id())] = block.get_node("vbox_block/lines").get_text().percent_encode() # NEED TO BE SPLIT
		nodeDict["anim"+str(block.get_id())] = block.get_node("vbox_block/anim").get_text().percent_encode()
		nodeDict["hidden"+str(block.get_id())] = block.is_hidden_state()
		
	node_list.push_back(nodeDict)

func load_data(data):
	_on_remove_pressed(nodes_lines[0])
	set_name( data["id"])
	set_offset( Vector2(data["x"], data["y"]))

	var currentBlock = 0
	var keyLine = "lines" 
	var keyAnim = "anim"
	var keyHidden = "hidden"
	while data.has( keyLine + str(currentBlock)) and data.has( keyAnim + str(currentBlock)):
		_add_line()
		nodes_lines[currentBlock].get_node("vbox_block/lines").set_text(data[keyLine + str(currentBlock)])
		nodes_lines[currentBlock].get_node("vbox_block/anim").set_text(data[keyAnim + str(currentBlock)])
		if data[keyHidden + str(currentBlock)] == true:
			nodes_lines[currentBlock]._on_btn_hide_pressed()
		currentBlock += 1
	
	

func export_gdscript(file, connections, labels):
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
