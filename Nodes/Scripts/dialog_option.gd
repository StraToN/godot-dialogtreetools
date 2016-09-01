extends "res://Nodes/Globals/dialognode.gd"

func _init():
	self.type = "dialog_option"
	self.block_scene = "res://Nodes/SubNodes/dialog_option_block.tscn"
	self.new_block_collapsed = true
	self.first_left_slot = true
	self.first_right_slot = true
	self.new_block_adds_left_slot = false
	self.new_block_adds_right_slot = true

func _ready():
	add_new_block()


func load_data(data):
	set_id( data["id"] )