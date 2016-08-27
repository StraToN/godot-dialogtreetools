tool
extends EditorPlugin

var dock = null

var window

func _enter_tree():
	window = preload("res://window.tscn").instance()

	add_control_to_bottom_panel ( window, "Tree editor" )

func _exit_tree():

	# Remove from bottom panel (must be called so layout is updated and saved)
	remove_control_from_bottom_panel(window)
	# Remove the node
	window.free()