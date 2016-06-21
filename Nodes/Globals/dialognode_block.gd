extends Container

var id setget set_id,get_id
export(NodePath) var block_to_collapse_path setget set_block_to_collapse_path,get_block_to_collapse_path
var block_to_collapse setget set_block_to_collapse,get_block_to_collapse
	
func _ready():
	if (block_to_collapse_path != null):
		set_block_to_collapse(get_node(block_to_collapse_path))
	get_node("hbox/btn_hide").connect("pressed", get_parent(), "_on_collapse_block_pressed", [self])

func set_id(v):
	id = v
	get_node("hbox/id").set_text(str(id))

func get_id():
	return id

func set_block_to_collapse_path(v):
	block_to_collapse_path = v
	block_to_collapse = get_node(v)

func get_block_to_collapse_path():
	return block_to_collapse_path

func set_block_to_collapse(v):
	block_to_collapse = v

func get_block_to_collapse():
	return block_to_collapse