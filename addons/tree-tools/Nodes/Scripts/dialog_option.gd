tool
extends "res://addons/tree-tools/Nodes/Globals/dialognode.gd"

func _init():
	self.type = "dialog_option"
	self.block_scene = "res://addons/tree-tools/Nodes/SubNodes/dialog_option_block.tscn"
	self.new_block_collapsed = true
	self.first_left_slot = true
	self.first_right_slot = true
	self.new_block_adds_left_slot = false
	self.new_block_adds_right_slot = true
	self.left_slot_type = 0
	self.right_slot_type = 0

func _ready():
	add_new_block()


func load_data(data):
	set_id( data["id"] )
	set_name( data["id"] )