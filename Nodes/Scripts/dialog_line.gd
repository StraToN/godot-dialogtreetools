extends "res://Nodes/Globals/dialognode.gd"


func _init():
	self.type = "dialog_line"
	self.block_scene = "res://Nodes/SubNodes/dialog_line_block.tscn"
	self.new_block_adds_left_slot = false
	self.new_block_adds_right_slot = false

func _ready():
	add_new_block()


func load_data(data):
	_on_remove_pressed(nodes_blocks[0])
	set_id( data["id"])
	set_offset( Vector2(data["x"], data["y"]))

	var currentBlock = 0
	var keyLine = "lines" 
	var keyAnim = "anim"
	var keyHidden = "hidden"
	while data.has( keyLine + str(currentBlock)) and data.has( keyAnim + str(currentBlock)):
		_add_line()
		nodes_blocks[currentBlock].get_node("vbox_block/lines").set_text(data[keyLine + str(currentBlock)])
		nodes_blocks[currentBlock].get_node("vbox_block/anim").set_text(data[keyAnim + str(currentBlock)])
		if data[keyHidden + str(currentBlock)] == true:
			nodes_blocks[currentBlock]._on_btn_hide_pressed()
		currentBlock += 1