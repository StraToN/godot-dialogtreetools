tool
extends ScrollContainer

func _ready():
	init_option_buttons()

func init_option_buttons():
	for c in get_node("VBoxContainer").get_children():
		c.connect("pressed", self, "on_option_pressed", [c])
		c.set_text(c.get_name())

func on_option_pressed(c):
	print("pressed!")
	print(c)