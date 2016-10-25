tool
extends EditorPlugin

var tree_tools = null
const TreeNode = preload("res://addons/tree-tools/TreeNode/TreeNode.gd")

var current_object

func _enter_tree():
	add_custom_type("TreeNode", "Node", preload("res://addons/tree-tools/TreeNode/TreeNode.gd"), preload("res://addons/tree-tools/TreeNode/icons/gear.png"))
	
	tree_tools = preload("res://addons/tree-tools/window.tscn").instance()
	
	# resize
	_on_resized()
	get_editor_viewport().connect("resized", self, "_on_resized")
	
	make_visible(false)
	
	get_editor_viewport().add_child(tree_tools)
#	tree_tools.get_node("Panel/editor").init()


func _exit_tree():
	tree_tools.queue_free()
	remove_custom_type("TreeNode")


func get_name():
	return "Tree-tools"

func has_main_screen():
	return true

func handles(object):
	return object extends TreeNode


func edit(object):
	current_object = object
	

func make_visible(visible):
	if (visible):
		tree_tools.show()
	else:
		tree_tools.hide()


func _on_resized():
	print("RESIZED!")
	var viewport_size = get_editor_viewport().get_size()
	tree_tools.set_size(viewport_size)
	tree_tools.get_node("Panel").set_size(viewport_size)
	#tree_tools.get_node("Panel/editor").set_size(viewport_size)
