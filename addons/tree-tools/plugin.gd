tool
extends EditorPlugin


const TREENODE = preload("res://addons/tree-tools/TreeNode/TreeNode.gd")
const TREENODERESOURCE = preload("res://addons/tree-tools/TreeNode/TreeNodeResource.gd")
var TREETOOL = preload("res://addons/tree-tools/treetool.tscn")
var TREENODE_ICON = preload("res://addons/tree-tools/TreeNode/icons/gear.png")

var tree_tools = null # plugin container
var current_object
var objects_list # list of objects to save on save_external_resources

func _enter_tree():	
	add_custom_type("TreeNode", "Node", TREENODE, TREENODE_ICON)
	add_custom_type("TreeNodeResource", "Resource", TREENODERESOURCE, null)
	
	instanciate_treetool()
	get_editor_interface().get_editor_viewport().add_child(tree_tools)
	
	make_visible(false)


# Free every custom types and resources when disabling the plugin
func _exit_tree():
	if tree_tools != null:
		get_editor_interface().get_editor_viewport().remove_child(tree_tools)
		tree_tools.clear()
		tree_tools.queue_free()
	remove_custom_type("TreeNode")
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
	#return object is TREENODERESOURCE || (object is TREENODE && object.resource != null)
	return object is TREENODE && object.resource != null


# OVERRIDE
func edit(object):
	print("JUST SELECTED")
	debug_print(object)
	
	print("CURRENT")
	debug_print(current_object)
	
	if current_object != null:
		# save current graph to current_object
		if current_object is TREENODE:
			current_object.resource.dict = tree_tools.get_dictionary()
			var res_file = "res://dialogtrees_resources/" + current_object.get_name()+".tres"
			current_object.external_path = res_file
		save_external_data()

	# switch current_object
	if current_object == object || !handles(object) || object == null:
		return
	
	# add new object in list of objects
	current_object = object
	
	print("NEW CURRENT")
	debug_print(current_object)
	
	# load new current_object data into graph
	#tree_tools.clear()

	if current_object is TREENODE:
		if current_object.resource != null && current_object.resource is TREENODERESOURCE:
			tree_tools.load_from_dict(current_object.resource.dict)
			make_visible(true)
	elif current_object is TREENODERESOURCE:
		tree_tools.load_from_dict(current_object.dict)
		make_visible(true)
	
	
func get_state():
	return

func set_state(state):
	tree_tools.set_state(state)

# OVERRIDE
func clear():
	if tree_tools != null:
		tree_tools.clear()

# OVERRIDE
func make_visible(visible):
	if tree_tools != null:
		if visible:
			print("MAKE VISIBLE")
			tree_tools.show()
			print(tree_tools.get_children())
		else:
			print("MAKE HIDDEN")
			tree_tools.hide()
		print(str(tree_tools) + " " + tree_tools.name)

func save_external_data():
	print("ON SAVE CALLED")
	if current_object != null:
		print("current_object=", current_object)
		if current_object is TREENODERESOURCE:
			current_object.dict = tree_tools.get_dictionary()
			ResourceSaver.save(current_object.external_path, current_object)
			print("Saving TreeNodeResource in > ", current_object.external_path)
		elif current_object is TREENODE:
			if current_object is TREENODE:
				current_object.resource.dict = tree_tools.get_dictionary()
			if (current_object.external_path != null):
				ResourceSaver.save(current_object.external_path, current_object.resource)
				print("Saving TreeNode in > ", current_object.external_path)
			else:
				print("Error saving TreeNode: Resource external path is null")
				

func instanciate_treetool():
	tree_tools = TREETOOL.instance()
	tree_tools.EDITORPLUGIN = self


func debug_print(object):
	if object != null:
		printt("\tobject: ", object)
		if object is TREENODE:
			printt("\ttype:", "TreeNode")
		elif object is TREENODERESOURCE:
			printt("\ttype:", "TreeNodeResource")
		printt("\tCONTAINS:")
		if object is TREENODE:
			if object.resource != null && object.resource is TREENODERESOURCE:
				printt("\t\t", object.resource.dict)
	