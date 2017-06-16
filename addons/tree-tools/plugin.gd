tool
extends EditorPlugin


const TreeNode = preload("res://addons/tree-tools/TreeNode/TreeNode.gd")
const TreeNodeResource = preload("res://addons/tree-tools/TreeNode/TreeNodeResource.gd")

var tree_tools = null # plugin container
var current_object
var objects_list # list of objects to save on save_external_resources

func _enter_tree():
	var node_icon = preload("res://addons/tree-tools/TreeNode/icons/gear.png")
	add_custom_type("TreeNode", "Node", TreeNode, node_icon)
	add_custom_type("TreeNodeResource", "Resource", TreeNodeResource, null)
	
	tree_tools = preload("res://addons/tree-tools/treetool.tscn").instance()
	
	# resize
	_on_resized()
	get_editor_viewport().connect("resized", self, "_on_resized")
	
	make_visible(false)

	get_editor_viewport().add_child(tree_tools)

# Free every custom types and resources when disabling the plugin
func _exit_tree():
	if (tree_tools != null):
		tree_tools.clear()
		tree_tools.queue_free()
	remove_custom_type("TreeNode")
	remove_custom_type("TreeNodeResource")

# Plugin name
func get_name():
	return "Tree-tools"

# Plugin does have a main screen view
func has_main_screen():
	return true

# function called by editor to ask if the object is managed by plugin
func handles(object):
	#return object extends TreeNodeResource || (object extends TreeNode && object.resource != null)
	return object extends TreeNode && object.resource != null

func edit(object):

	print("JUST SELECTED")
	debug_print(object)
	
	print("CURRENT")
	debug_print(current_object)
	
	if current_object != null:
		# save current graph to current_object
		if current_object extends TreeNode:
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
	tree_tools.clear()

	if current_object extends TreeNode:
		if current_object.resource != null && current_object.resource extends TreeNodeResource:
			tree_tools.load_from_dict(current_object.resource.dict)
	elif current_object extends TreeNodeResource:
		tree_tools.load_from_dict(current_object.dict)
	

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

func save_external_data():
	print("ON SAVE CALLED")
	if current_object != null:
		print("current_object=", current_object)
		if current_object extends TreeNodeResource:
			current_object.dict = tree_tools.get_dictionary()
			ResourceSaver.save(current_object.external_path, current_object)
			print("Saving TreeNodeResource in > ", current_object.external_path)
		elif current_object extends TreeNode:
			if current_object extends TreeNode:
				current_object.resource.dict = tree_tools.get_dictionary()
			if (current_object.external_path != null):
				ResourceSaver.save(current_object.external_path, current_object.resource)
				print("Saving TreeNode in > ", current_object.external_path)
			else:
				print("Error saving TreeNode: Resource external path is null")


func _on_resized():
	var viewport_size = get_editor_viewport().get_size()
	tree_tools.set_size(viewport_size)
	tree_tools.get_node("Panel").set_size(viewport_size)


func debug_print(object):
	if object != null:
		printt("\tobject: ", object)
		if object extends TreeNode:
			printt("\ttype:", "TreeNode")
		elif object extends TreeNodeResource:
			printt("\ttype:", "TreeNodeResource")
		printt("\tCONTAINS:")
		if object extends TreeNode:
			if object.resource != null && object.resource extends TreeNodeResource:
				printt("\t\t", object.resource.dict)
	