
extends "res://Nodes/Globals/dialognode_block.gd"

func _ready():
	pass

func _on_item_action_selected( ID ):
	var hbox_to_show = "box_" + get_node("hbox/option_btn_action").get_item_text(ID)
	for hboxesnodes in get_node("vbox_block/hBoxContainer").get_children():
		if (hboxesnodes.get_name() == hbox_to_show):
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).show()
		else:
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).hide()
