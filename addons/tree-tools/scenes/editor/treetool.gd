tool
extends PanelContainer

onready var editor = $VBoxContainer/HSplitContainer/graphedit
onready var node_editor = $VBoxContainer/HSplitContainer/node_editor

func _ready():
	$save_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$save_dialog.set_mode($save_dialog.MODE_SAVE_FILE)
	$save_dialog.add_filter("*.json;JavaScript Object Notation")
	
	$load_dialog.set_access($save_dialog.ACCESS_FILESYSTEM)
	$load_dialog.set_mode($save_dialog.MODE_OPEN_FILE)
	$load_dialog.add_filter("*.json;JavaScript Object Notation")
	
# Helper function to clear the GraphEdit
func clear():
	if editor != null:
		editor.clear()

func _on_resized():
	# set the size of the top panel and GraphEdit to the same as the frame on resize
	#var vpSize = get_tree().get_root().get_rect().size
	editor.set_size( get_rect().size )

func _on_import_button_pressed():
	if not get_node("save_dialog").visible:
		get_node("save_dialog").hide()
	get_node("load_dialog").popup_centered()


func _on_export_button_pressed():
	if not get_node("load_dialog").visible:
		get_node("load_dialog").hide()
	get_node("save_dialog").popup_centered()

func _on_editor_graphnode_selected(graphnode):
	var dict = {}
	node_editor.show_data_for_graphnode(graphnode, dict)

func _on_editor_graphnode_unselected(graphnode):
	node_editor.update_changes_to_graphnode()
	node_editor.hide_editor()

func _on_node_editor_editor_instanced(editor_instance):
	if editor_instance is preload("res://addons/tree-tools/scenes/editor/globals/editor.gd"):
		
		if editor_instance.type == "line" ||  editor_instance.type == "option":
			editor_instance.connect("block_updated", editor, "_on_block_updated")


