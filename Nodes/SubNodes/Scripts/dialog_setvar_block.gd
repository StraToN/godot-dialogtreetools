
extends VBoxContainer

export(int) var id

var types_list = ["Boolean", "Integer", "Float", "String"]

func _ready():
	for types in types_list:
		get_node("hbox1/type").add_item(types)
	get_node("hbox1/type").connect("item_selected", self, "_on_type_changed")
	
	pass

func _on_type_changed(type):
	if type == 0:
		get_node("hbox1/bool_value").show()
		get_node("hbox1/value").hide()
	else:
		get_node("hbox1/bool_value").hide()
		get_node("hbox1/value").show()

func set_id(v):
	id = v
	

func add_addbutton(parent):
	var btnAdd = Button.new()
	btnAdd.set_name("addbtn")
	btnAdd.set_text("+")
	btnAdd.connect("pressed", parent, "_on_add_pressed")
	get_node("hbox").add_child(btnAdd)
	
	
func add_rembutton(parent):
	var btnRemove = Button.new()
	btnRemove.set_name("rembtn")
	btnRemove.set_text("-")
	btnRemove.connect("pressed", parent, "_on_remove_pressed", [self])
	get_node("hbox").add_child(btnRemove)


func hide_rembutton():
	get_node("hbox/rembtn").hide()
	
	
func show_rembutton():
	get_node("hbox/rembtn").show()



func get_variable():
	if get_node("hbox1/type").get_selected() == 0:
		return [ get_node("hbox/name"), get_node("hbox1/type"), get_node("hbox2/bool_value") ]
	else:
		return [ get_node("hbox/name"), get_node("hbox1/type"), get_node("hbox2/value") ]
