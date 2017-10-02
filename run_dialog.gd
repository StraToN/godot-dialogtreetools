extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print(get_tree().get_root().get_node("dialog_manager"))
	connect("pressed", get_node("../dialog_manager"), "execute_dialog", [get_node("../Sprite")])

