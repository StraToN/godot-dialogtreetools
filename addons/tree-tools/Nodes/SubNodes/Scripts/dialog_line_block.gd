tool
extends "res://addons/tree-tools/Nodes/Globals/dialognode_block.gd"

func _ready():
	pass

# On "action" combobox change
func _on_item_action_selected( ID ):
	var hbox_to_show = "box_" + get_node("hbox/option_btn_action").get_item_text(ID)
	for hboxesnodes in get_node("vbox_block/hBoxContainer").get_children():
		if (hboxesnodes.get_name() == hbox_to_show):
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).show()
		else:
			get_node("vbox_block/hBoxContainer/"+hboxesnodes.get_name()).hide()

func get_data():
	var id = int(get_node("hbox/id").get_text())
	var action_id = get_node("hbox/option_btn_action").get_selected()
	var data = {}
	data["id"] = id
	data["action_id"] = action_id
	data["collapsed"] = is_collapsed()

	if (action_id == 0): # SAY
		var actor = get_node("vbox_block/hBoxContainer/box_say/HBoxContainer/text").get_text()
		var dialog = get_node("vbox_block/hBoxContainer/box_say/HBoxContainer2/dialog").get_text()
		var animation = get_node("vbox_block/hBoxContainer/box_say/HBoxContainer2/animation").get_text()
		data["actor"] = actor
		data["dialog"] = dialog
		data["animation"] = animation
	elif (action_id == 1): # ANIM
		var actor = get_node("vbox_block/hBoxContainer/box_anim/HBoxContainer1/actor").get_text()
		var animation = get_node("vbox_block/hBoxContainer/box_anim/HBoxContainer2/animation").get_text()
		data["actor"] = actor
		data["animation"] = animation
	elif (action_id == 2): # WALKTO
		var actor = get_node("vbox_block/hBoxContainer/box_walkto/hbox/actor").get_text()
		var pos2d_nodepath = get_node("vbox_block/hBoxContainer/box_walkto/vbox/pos2d_nodepath").get_text()
		data["actor"] = actor
		data["pos2d_nodepath"] = pos2d_nodepath
	elif (action_id == 3): # TELEPORT
		var actor = get_node("vbox_block/hBoxContainer/box_teleport/hbox/actor").get_text()
		var pos2d_nodepath = get_node("vbox_block/hBoxContainer/box_teleport/hbox1/pos2d_nodepath1").get_text()
		data["actor"] = actor
		data["pos2d_nodepath"] = pos2d_nodepath
	return data

func set_data(data):
	get_node("hbox/id").set_text(str(data["id"]))
	get_node("hbox/option_btn_action").select(data["action_id"])
	if (data["collapsed"]):
		_on_collapse_block_pressed()
	
	if (data["action_id"] == 0):	# SAY
		get_node("vbox_block/hBoxContainer/box_say/HBoxContainer/text").set_text(data["actor"])
		get_node("vbox_block/hBoxContainer/box_say/HBoxContainer2/dialog").set_text(data["dialog"])
		get_node("vbox_block/hBoxContainer/box_say/HBoxContainer2/animation").set_text(data["animation"])
	elif (data["action_id"] == 1):	# ANIM
		get_node("vbox_block/hBoxContainer/box_walkto/hbox/actor").set_text(data["actor"])
		get_node("vbox_block/hBoxContainer/box_walkto/vbox/pos2d_nodepath").set_text(data["animation"])
	elif (data["action_id"] == 2):	# WALKTO
		get_node("vbox_block/hBoxContainer/box_walkto/hbox/actor").set_text(data["actor"])
		get_node("vbox_block/hBoxContainer/box_walkto/vbox/pos2d_nodepath").set_text(data["pos2d_nodepath"])
	elif (data["action_id"] == 3):	# TELEPORT
		get_node("vbox_block/hBoxContainer/box_teleport/hbox/actor").set_text(data["actor"])
		get_node("vbox_block/hBoxContainer/box_teleport/hbox1/pos2d_nodepath1").set_text(data["pos2d_nodepath"])