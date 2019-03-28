tool
extends EditorPlugin


#const TREENODE = preload("res://addons/tree-tools/TreeNode/TreeNode.gd")
const TreeNodeResource = preload("res://addons/tree-tools/resources/treenode_data.gd")

var TREETOOL = preload("res://addons/tree-tools/scenes/editor/treetool.tscn")
var TREENODE_ICON = preload("res://addons/tree-tools/icons/gear.png")


var tree_tools = null # plugin container
var node_editor = null # bottom panel container
var current_object
var objects_list # list of objects to save on save_external_resources


func _enter_tree():	
	#add_custom_type("TreeNode", "Node", TREENODE, TREENODE_ICON)
	add_custom_type("TreeNodeResource", "Resource", TreeNodeResource, null)
	
	tree_tools = TREETOOL.instance()
	
	get_editor_interface().get_editor_viewport().add_child(tree_tools)

	make_visible(false)


# Free every custom types and resources when disabling the plugin
func _exit_tree():
	#if tree_tools != null:
	get_editor_interface().get_editor_viewport().remove_child(tree_tools)
	tree_tools.queue_free()
	tree_tools = null
		
#	remove_custom_type("TreeNode")
	remove_custom_type("TreeNodeResource")
	

# OVERRIDE
# Plugin name
func get_plugin_name():
	return "Tree-tools"

func get_plugin_icon():
	return TREENODE_ICON


# OVERRIDE
# Plugin does have a main screen view
func has_main_screen():
	return true


# OVERRIDE
# function called by editor to ask if the object is managed by plugin
func handles(object):
	return object is TreeNodeResource # || (object is TREENODE && object.resource != null)

# OVERRIDE
func edit(object):
	print("Edit ", object)
	if object == null:
		return
	
	if object is TreeNodeResource:
		make_visible(true)
	else:
		make_visible(false)
	
func get_state():
	return

func set_state(state):
	tree_tools.set_state(state)

# OVERRIDE
func clear():
	tree_tools.clear()

# OVERRIDE
func make_visible(visible):
	if visible:
		tree_tools.show()
	else:
		tree_tools.hide()
		
		# TODO Workaround https://github.com/godotengine/godot/issues/6459
		# When the user selects another node, I want the plugin to release 
		# its references to the dialog tree.
		edit(null)
		