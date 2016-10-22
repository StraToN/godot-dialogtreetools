tool
extends EditorPlugin

var tree_tools = null
var test = null

func get_name():
	return "Tree-tools"
	
func get_base_control():
	return get_parent().get_gui_base()

func has_main_screen():
	return true

	
func _enter_tree():
	tree_tools = preload("res://addons/tree-tools/window.tscn").instance()
	
	# resize
	_on_resized()
	get_editor_viewport().connect("resized", self, "_on_resized")
	
	get_editor_viewport().add_child(tree_tools)
	tree_tools.get_node("Panel/editor").init()
	
func _on_resized():
	print("RESIZED!")
	var viewport_size = get_editor_viewport().get_size()
	print(viewport_size)
	tree_tools.set_size(viewport_size)
	tree_tools.get_node("Panel").set_size(viewport_size)
	#tree_tools.get_node("Panel/editor").set_size(viewport_size)
	
func _exit_tree():
	tree_tools.queue_free()
	