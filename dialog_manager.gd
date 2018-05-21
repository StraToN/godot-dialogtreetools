extends Node

onready var timer_dialog = Timer.new()	# This timer is started when a line is spoken by a character. 
										# After that, it automatically calls the update_line() function 
										# to get to the next one.
onready var timer_dialog_player = Timer.new()	# This timer is the same for player, but only calls 
												# a function to hide its line when finished.

var line = ""			# Current line to say by character
var line_player = ""	# Same for player
var lines_list			# List of lines to be spoken
var dialogs_count_in_state # Counter for Dialog Lines, if the current Dialog Line counter multiple lines at once
var parent_of_treenode	# Parent of the TreeNode, so we can make its character talk
						# Normally this would NOT be managed like that, as we want our dialogs to be able to make 
						# any character talk, so we might need a Global dialog manager instead of this script here.
						# But hey, it's a demo. :)
onready var is_option_chosen = false	# True if we just managed an option choice.
var option_id			# in case of Option node, this is the Option node that was chosen by the player
var option_block_chosen	# in case of Option node, this is the block in the Option node that was chosen by the player

func _ready():
	timer_dialog.connect("timeout", self, "update_line")
	add_child(timer_dialog)
	timer_dialog_player.connect("timeout", self, "player_finished_speaking")
	timer_dialog_player.set_one_shot(true)
	add_child(timer_dialog_player)


func state_finished():
	timer_dialog_player.stop()
	print("STATE FINISHED")
	execute_dialog(parent_of_treenode)
	

func execute_dialog(parent):
	parent_of_treenode = parent
	var nodesList
	if (!is_option_chosen):
		nodesList = parent_of_treenode.get_node("TreeNode").advance_state()
	else:
		print("here after option chosen")
		printt(option_id, option_block_chosen)
		nodesList = parent_of_treenode.get_node("TreeNode").advance_state_option(option_id, option_block_chosen)
	is_option_chosen = false
	
	print("NODES LIST")
	print(nodesList)
	
	if nodesList.size() == 0:
		# END OF DIALOG, DO NOTHING
		return
	
	var node = nodesList[0]
	
	if node.type == "dialog_line":
		lines_list = node.data0.dialog.split("%%")
		dialogs_count_in_state = 0
		update_line()
		
	elif node.type == "dialog_option":
		var options_list = []
		for i in range(0, node.nb_blocks):
			options_list.append(node["data"+str(i)])
		
		print("OPTIONS LIST")
		print(options_list)
		## Manage options...
		get_node("../player/dialog").set_text("OPTION")
		get_node("option_chooser").set_options(node.id, options_list)


func update_line():
	if (dialogs_count_in_state >= lines_list.size()):
		timer_dialog.stop()
		parent_of_treenode.get_node("dialog").set_text("")
		state_finished()
		return

	line = lines_list[dialogs_count_in_state]
	say_line(line)
	dialogs_count_in_state += 1
	print(dialogs_count_in_state)
	
func say_line(l):
	parent_of_treenode.get_node("dialog").set_text(l)
	var number_of_spaces = l.split(" ").size()
	var time_line = l.length() * 0.4 / number_of_spaces
	timer_dialog.set_wait_time(time_line)
	timer_dialog.start()

func answer_option(option_id, option_block_chosen):
	line_player = option_block_chosen.option
	say_player_line()
	var number_of_spaces = line.split(" ").size()
	var time_line = line.length() * 0.4 / number_of_spaces
	timer_dialog_player.set_wait_time(time_line)
	line_player = ""
	timer_dialog_player.start()
	self.is_option_chosen = true
	self.option_id = option_id
	self.option_block_chosen = option_block_chosen

func say_player_line():
	get_node("../player/dialog").set_text(line_player)

func player_finished_speaking():
	line_player = ""
	get_node("../player/dialog").set_text(line_player)
	state_finished()