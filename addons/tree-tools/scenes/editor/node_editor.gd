tool
extends Control

signal editor_instanced(editor_instance)

var BlocksStack = preload("res://addons/tree-tools/scenes/editor/globals/blocks_stack.gd")

var editors = {
	"line": preload("res://addons/tree-tools/scenes/editor/line_edit/line_editor.tscn"),
	"start": preload("res://addons/tree-tools/scenes/editor/start_edit/start_edit.tscn"),
	"option": preload("res://addons/tree-tools/scenes/editor/option_edit/option_editor.tscn")
}

var graphnode_editor_instances = {}

func clear():
	for c in get_children():
		remove_child(c)

func show_data_for_graphnode(graphnode, data_json):
	clear()
	if graphnode == null:
		return
	printt("GRAPHNODE TYPE", graphnode.get_graphnode_type())
	
	if graphnode_editor_instances.has(graphnode):
		add_child(graphnode_editor_instances[graphnode])
	else:
		var ui_editor = editors[graphnode.get_graphnode_type()].instance()
		add_child(ui_editor)
		
		graphnode_editor_instances[graphnode] = ui_editor
		emit_signal("editor_instanced", ui_editor)
		
		# if the editor is block based, instance the first one and notify up
		# so that the according graphnode shows the option
		if ui_editor is BlocksStack:
			if ui_editor.blocks_instances.size() == 0:
				ui_editor.instance_block(null)
	
	#editor.load_data(data_json)




func hide_editor():
	print("NO SELECTION")
	clear()
