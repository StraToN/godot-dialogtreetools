tool
extends "../../Globals/dialognode_block.gd"


func _ready():
	get_node("hbox1/type").connect("item_selected", self, "_on_type_changed")

# Display GUI elements according to selected type
func _on_type_changed(type):
	if type == 0: # BOOLEAN
		get_node("hbox1/bool_value").show()
		get_node("hbox1/value").hide()
	else:
		get_node("hbox1/bool_value").hide()
		get_node("hbox1/value").show()

func get_variable():
	if get_node("hbox1/type").get_selected() == 0:
		return [ get_node("hbox/name"), get_node("hbox1/type"), get_node("hbox2/bool_value") ]
	else:
		return [ get_node("hbox/name"), get_node("hbox1/type"), get_node("hbox2/value") ]

func get_data():
	var id = int(get_node("hbox/id").get_text())
	var name = get_node("hbox/name").get_text()
	var type = get_node("hbox1/type").get_selected()
	var data = {}
	data["id"] = id
	data["name"] = name
	data["type"] = type
	data["collapsed"] = is_collapsed()
	
	if (type == 0): # BOOLEAN
		var bool_value = get_node("hbox1/bool_value").is_pressed()
		data["bool_value"] = bool_value
	elif (type == 1): # INT
		var value = get_node("hbox1/value").get_text()
		data["value"] = int(value)
	elif (type == 2): # FLOAT 
		var value = get_node("hbox1/value").get_text()
		data["value"] = float(value)
	elif (type == 3): # STRING
		var value = get_node("hbox1/value").get_text()
		data["value"] = value
	return data
	
func set_data(data):
	get_node("hbox/id").set_text(str(data["id"]))
	get_node("hbox/name").set_text(data["name"])
	get_node("hbox1/type").set_selected(data["type"])
	if (data["type"] == 0):
		get_node("hbox1/bool_value").set_text(data["bool_value"])
	else:
		get_node("hbox1/value").set_text(data["value"])
	set_collapsed(data["collapsed"])