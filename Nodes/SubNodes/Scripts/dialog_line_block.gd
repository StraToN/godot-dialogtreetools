
extends VBoxContainer

var id setget set_id,get_id

func _ready():
	get_node("hbox/btn_hide").connect("pressed", get_parent(), "_on_hide_block_pressed", [get_node("vbox_block")])

func set_id(v):
	id = v
	get_node("hbox/id").set_text(str(id))

func get_id():
	return id

func _on_item_action_selected( ID ):
	var hbox_to_show = "box_" + get_node("hbox/option_btn_action").get_item_text(ID)
	for hboxesnodes in get_node("vbox_block/hBoxContainer").get_children():
		if (hboxesnodes.get_name() == hbox_to_show):
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).show()
		else:
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).hide()
