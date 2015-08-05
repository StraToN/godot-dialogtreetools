
extends VBoxContainer

export(int) var id

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass


func set_id(v):
	id = v

func get_id():
	return id


func add_addbutton(parent):
	var btnAdd = Button.new()
	btnAdd.set_name("addbtn")
	btnAdd.set_text("+")
	print(parent)
	btnAdd.connect("pressed", parent, "_on_add_pressed")
	get_node("hbox").add_child(btnAdd)
	
	
func add_rembutton(parent):
	var btnRemove = Button.new()
	btnRemove.set_name("rembtn")
	btnRemove.set_text("-")
	print(parent)
	btnRemove.connect("pressed", parent, "_on_remove_pressed", [self])
	get_node("hbox").add_child(btnRemove)


func hide_rembutton():
	get_node("hbox/rembtn").hide()
	
	
func show_rembutton():
	get_node("hbox/rembtn").show()


func _on_btn_hide_pressed():
	if get_node("vbox_block").is_hidden():
		get_node("vbox_block").show()
		get_node("hbox/lbl_first_line").hide()
	else:
		get_node("vbox_block").hide()
		
		var textlines = get_node("vbox_block/lines").get_text()
		var nbLines = (textlines.split("\n")).size()
		if textlines == "":
			nbLines = 0
		var cutText = textlines.split("\n")[0].substr(0, 60)
		if nbLines > 0:
			cutText += "... (" + str(nbLines) + ")"
		get_node("hbox/lbl_first_line").set_text( cutText )
		get_node("hbox/lbl_first_line").show()
	pass # replace with function body
