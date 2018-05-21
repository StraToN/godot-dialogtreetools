tool
extends "res://addons/tree-tools/Nodes/Globals/node_block.gd"


func _ready():
	$hbox1/type.connect("item_selected", self, "_on_type_changed")
	pass

# Display GUI elements according to selected type
func _on_type_changed(type):
	if type == 0: # BOOLEAN
		$hbox1/bool_value.show()
		$hbox1/value.hide()
	else:
		$hbox1/bool_value.hide()
		$hbox1/value.show()

func get_variable():
	if $hbox1/type.get_selected() == 0:
		return [ $hbox/name, $hbox1/type, $hbox2/bool_value ]
	else:
		return [ $hbox/name, $hbox1/type, $hbox2/value ]

func get_data():
	var id = int($hbox/id.get_text())
	var name = $hbox/name.get_text()
	var type = $hbox1/type.get_selected()
	var data = {}
	data["id"] = id
	data["name"] = name
	data["type"] = type
	data["collapsed"] = is_collapsed()
	
	if (type == 0): # BOOLEAN
		var bool_value = $hbox1/bool_value.is_pressed()
		data["bool_value"] = bool_value
	elif (type == 1): # INT
		var value = $hbox1/value.get_text()
		data["value"] = int(value)
	elif (type == 2): # FLOAT 
		var value = $hbox1/value.get_text()
		data["value"] = float(value)
	elif (type == 3): # STRING
		var value = $hbox1/value.get_text()
		data["value"] = value
	return data
	
func set_data(data):
	$hbox/id.set_text(str(data["id"]))
	$hbox/name.set_text(data["name"])
	$hbox1/type.set_selected(data["type"])
	if (data["type"] == 0):
		$hbox1/bool_value.set_text(data["bool_value"])
	else:
		$hbox1/value.set_text(data["value"])
	set_collapsed(data["collapsed"])