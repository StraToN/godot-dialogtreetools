tool
extends EditorPlugin

var tree_tools = null
var tree

static func get_name():
	return "tree-tools"
	
func clear():
	tree_tools.clear_state()
	
func get_base_control():
	return get_parent().get_gui_base()
	
func get_selected():
	var item = tree.get_selected()
	
	if not item:
		return
		
	var path = item.get_metadata(0)
	
	if has_node(path):
		return get_node(path)
		
	return null
	
func _find_node(type, node):
	if node.is_type(type):
		return node
		
	for i in range(node.get_child_count()):
		var n = _find_node(type, node.get_child(i))
		
		if n:
			return n
			
	return null
	
func _enter_tree():
	tree_tools = preload("res://addons/tree-tools/window.tscn").instance()
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, tree_tools)
	
	tree_tools.get_parent().move_child(tree_tools, 5)
	
	var scene_tree_dock = _find_node('SceneTreeDock', get_parent())
	
	var scene_editor = _find_node('SceneTreeEditor', scene_tree_dock)
	tree = scene_editor.get_child(0)
	
	print("TREE-TOOLS INIT")
	
func _exit_tree():
	tree_tools.queue_free()
	