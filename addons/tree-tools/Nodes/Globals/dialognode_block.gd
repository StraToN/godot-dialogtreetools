tool
extends Container

var id setget set_id,get_id
export(NodePath) var block_to_collapse_path setget set_block_to_collapse_path,get_block_to_collapse_path
var block_to_collapse setget set_block_to_collapse,get_block_to_collapse
onready var is_collapsed = false setget ,is_collapsed
	
func _ready():
	if (block_to_collapse_path != null):
		set_block_to_collapse(get_node(block_to_collapse_path))
	if (get_node("hbox/btn_hide") != null):
		if (!get_node("hbox/btn_hide").is_connected("pressed", self, "_on_collapse_block_pressed")):
			get_node("hbox/btn_hide").connect("pressed", self, "_on_collapse_block_pressed")

func set_id(v):
	id = v
	get_node("hbox/id").set_text(str(id))

func get_id():
	return id

func set_block_to_collapse_path(v):
	block_to_collapse_path = v
	set_block_to_collapse(get_node(v))

func get_block_to_collapse_path():
	return block_to_collapse_path

func set_block_to_collapse(v):
	block_to_collapse = null
	if (v != null):
		block_to_collapse = v

func get_block_to_collapse():
	return block_to_collapse
	
func is_collapsed():
	return is_collapsed

# Show/Hide block button pressed, and resize GraphNode to its minimum size
func _on_collapse_block_pressed():
	# security : print error if node_to_collapse not set in the block node
	if (block_to_collapse == null):
		printt("ERROR: Node to collapse not set in block ", self.get_name())
		pass
	if block_to_collapse.is_hidden():
		block_to_collapse.show()
		is_collapsed = false
	else:
		block_to_collapse.hide()
		is_collapsed = true
		get_parent().set_size( Vector2(get_parent().get_minimum_size().x, 0) )
 