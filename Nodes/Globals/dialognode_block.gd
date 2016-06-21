extends Container

var id setget set_id,get_id
var block_to_collapse setget set_block_to_collapse,get_block_to_collapse

func _ready():
	print(get_parent())
	get_node("hbox/btn_hide").connect("pressed", get_parent(), "_on_collapse_block_pressed", [block_to_collapse])

func set_id(v):
	id = v
	get_node("hbox/id").set_text(str(id))

func get_id():
	return id

func set_block_to_collapse(v):
	block_to_collapse = v

func get_block_to_collapse():
	return id