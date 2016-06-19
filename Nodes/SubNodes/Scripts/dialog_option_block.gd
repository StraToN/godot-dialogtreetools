
extends VBoxContainer

var id setget set_id,get_id

func _ready():
	print(get_parent())
	get_node("hbox/btn_hide").connect("pressed", get_parent(), "_on_hide_block_pressed", [get_node("vbox_params")])

func set_id(v):
	id = v
	get_node("hbox/id").set_text(str(id))

func get_id():
	return id


