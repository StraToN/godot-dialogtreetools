tool
extends ScrollContainer

# Map linking Buttons to Option entry in the list
onready var option_button = {}
var option_id

func on_option_pressed(c):
	get_node("..").answer_option(option_id, option_button[c])
	for button in get_node("VBoxContainer").get_children():
		print(button)
		remove_child(button)
		button.queue_free()
	

func set_options(option_id, options_list):
	self.option_id = option_id
	for option in options_list:
		var btn = Button.new()
		btn.set_text(option.option)
		btn.connect("pressed", self, "on_option_pressed", [btn])
		option_button[btn] = option
		get_node("VBoxContainer").add_child(btn)