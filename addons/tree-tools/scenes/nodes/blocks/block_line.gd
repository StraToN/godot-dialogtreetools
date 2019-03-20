tool
extends "res://addons/tree-tools/scenes/globals/node_block.gd"

func _ready():
	pass

# On "action" combobox change
func _on_item_action_selected( ID ):
	var hbox_to_show = "box_" + $hbox/option_btn_action.get_item_text(ID)
	for hboxesnodes in $vbox_block.get_children():
		if (hboxesnodes.get_name() == hbox_to_show):
			get_node("vbox_block/"+hboxesnodes.get_name()).show()
		else:
			get_node("vbox_block/"+hboxesnodes.get_name()).hide()

func get_data():
	var id = int($hbox/id.get_text())
	var action_id = $hbox/option_btn_action.get_selected()
	var data = {}
	data["id"] = id
	data["action_id"] = action_id
	data["collapsed"] = is_collapsed()

	if (action_id == 0): # SAY
		var actor = $vbox_block/box_say/HBoxContainer/text.get_text()
		var dialog = $vbox_block/box_say/VBoxContainer/dialog.get_text()
		var animation = $vbox_block/box_say/VBoxContainer/animation.get_text()
		data["actor"] = actor
		data["dialog"] = dialog
		data["animation"] = animation
	elif (action_id == 1): # ANIM
		var actor = $vbox_block/box_anim/HBoxContainer1/actor.get_text()
		var animation = $vbox_block/box_anim/HBoxContainer2/animation.get_text()
		data["actor"] = actor
		data["animation"] = animation
	elif (action_id == 2): # WALKTO
		var actor = $vbox_block/box_walkto/hbox/actor.get_text()
		var pos2d_nodepath = $vbox_block/box_walkto/vbox/pos2d_nodepath.get_text()
		data["actor"] = actor
		data["pos2d_nodepath"] = pos2d_nodepath
	elif (action_id == 3): # TELEPORT
		var actor = $vbox_block/box_teleport/hbox/actor.get_text()
		var pos2d_nodepath = $vbox_block/box_teleport/hbox1/pos2d_nodepath1.get_text()
		data["actor"] = actor
		data["pos2d_nodepath"] = pos2d_nodepath
	return data

func set_data(data):
	$hbox/id.set_text(str(data["id"]))
	$hbox/option_btn_action.select(data["action_id"])
	if (data["collapsed"]):
		_on_collapse_block_pressed()
	
	if (data["action_id"] == 0):	# SAY
		$vbox_block/box_say/HBoxContainer/text.set_text(data["actor"])
		$vbox_block/box_say/HBoxContainer2/dialog.set_text(data["dialog"])
		$vbox_block/box_say/HBoxContainer2/animation.set_text(data["animation"])
	elif (data["action_id"] == 1):	# ANIM
		$vbox_block/box_walkto/hbox/actor.set_text(data["actor"])
		$vbox_block/box_walkto/vbox/pos2d_nodepath.set_text(data["animation"])
	elif (data["action_id"] == 2):	# WALKTO
		$vbox_block/box_walkto/hbox/actor.set_text(data["actor"])
		$vbox_block/box_walkto/vbox/pos2d_nodepath.set_text(data["pos2d_nodepath"])
	elif (data["action_id"] == 3):	# TELEPORT
		$vbox_block/box_teleport/hbox/actor.set_text(data["actor"])
		$vbox_block/box_teleport/hbox1/pos2d_nodepath1.set_text(data["pos2d_nodepath"])