tool
extends EditorPlugin

var tree_tools = null
const TreeNode = preload("res://addons/tree-tools/TreeNode/TreeNode.gd")
const node_icon = preload("res://addons/tree-tools/TreeNode/icons/gear.png")

var current_object

func _enter_tree():
	add_custom_type("TreeNode", "Node", TreeNode, node_icon)
	tree_tools = preload("res://addons/tree-tools/treetool.tscn").instance()
	
	# resize
	_on_resized()
	get_editor_viewport().connect("resized", self, "_on_resized")
	
	make_visible(false)

	get_editor_viewport().add_child(tree_tools)


func _exit_tree():
	if (tree_tools != null):
		tree_tools.queue_free()
	remove_custom_type("TreeNode")


func get_name():
	return "Tree-tools"

func has_main_screen():
	return true

# function called by editor to ask if the object is managed by plugin
func handles(object):
	return object extends TreeNode


func edit(object):
	if current_object == object:
		return
	if current_object == null:
		current_object = object
	
	# save the content of the graphedit in the TreeNode we're leaving from
	current_object.set_json(tree_tools.get_json_string())
	#print("\nold treenode " + current_object.get_name() + " contains: ", current_object.get_json())
	
	# get the json content saved in the newly selected TreeNode and load it into the graphedit
	current_object = object
	tree_tools.clear()
	
	if (current_object.get_json() == null):
		current_object.set_json({"connections":[], "nodes":[]})
	#printt("new treenode = " + current_object.get_name() + " contains: ", current_object.get_json())
	tree_tools.load_from_json(current_object.get_json())


func set_state(state):
	tree_tools.set_state(state)
	
func get_state():
	var state = {}
	tree_tools.get_state(state)
	return state

func clear():
	tree_tools.clear_state()

func make_visible(visible):
	if (visible):
		tree_tools.show()
	else:
		tree_tools.hide()


func _on_resized():
	var viewport_size = get_editor_viewport().get_size()
	tree_tools.set_size(viewport_size)
	tree_tools.get_node("Panel").set_size(viewport_size)
