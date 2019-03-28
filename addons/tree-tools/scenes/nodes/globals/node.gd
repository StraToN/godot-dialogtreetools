tool
extends GraphNode

var graphnode_id setget set_graphnode_id,get_graphnode_id
var graphnode_type setget set_graphnode_type,get_graphnode_type

signal graphnode_removed(graphnode)
signal graphnode_selected(graphnode)
signal graphnode_unselected(graphnode)

var selected_

func _ready():
	connect("close_request", self, "_on_close_request")
	connect("raise_request", self, "_on_raise_request")
	
func set_graphnode_id(id):
	graphnode_id = id
	
func get_graphnode_id():
	return graphnode_id

func set_graphnode_type(type):
	graphnode_type = type

func get_graphnode_type():
	return graphnode_type

func _on_close_request():
	emit_signal("graphnode_removed", self)
	queue_free()

func _on_raise_request():
	emit_signal("graphnode_selected", self)

func unselect():
	emit_signal("graphnode_unselected", self)
