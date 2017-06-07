tool
extends Button

onready var context_menu = get_node("../PopupMenu")

func _ready():
	connect("pressed", self, "on_add_button_pressed")

func on_add_button_pressed():
	context_menu.set_pos(get_global_mouse_pos())
	context_menu.popup()
