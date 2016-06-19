
extends Button

export(NodePath) var target_path

func _ready():
	connect("pressed", self, "_on_click")
	pass

func _on_click():
	if (has_node(target_path)):
		if (get_node(target_path).is_hidden()):
			get_node(target_path).show()
		else:
			get_node(target_path).hide()
