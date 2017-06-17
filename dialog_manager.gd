
onready var timerDialog = Timer.new()

var line = ""
var lines_list
var dialogs_count_in_state

func _ready():
	timerDialog.connect("timeout", self, "update_line")
	add_child(timerDialog)


func state_finished():
	print("STATE FINISHED")
	execute_dialog()
	

func execute_dialog():
	var nodesList = get_node("TreeNode").advance_state()
	print(nodesList)
	
	var node = nodesList[0]
	print("NODE:")
	print(node)
	
	if node.type == "dialog_line":
		lines_list = node.data0.dialog.split("%%")
		dialogs_count_in_state = 0
		update_line()
		
	elif node.type == "dialog_option":
		var optionsList = []
		for i in range(0, node.nb_blocks):
			optionsList.append(node["data"+str(i)])
		
		print("OPTIONS LIST")
		print(optionsList)
		## Manage options...
		get_node("../player/dialog").set_text("OPTION")


func update_line():
	if (dialogs_count_in_state >= lines_list.size()):
		timerDialog.stop()
		get_node("dialog").set_text("")
		state_finished()
		return

	line = lines_list[dialogs_count_in_state]
	say_line(line)
	dialogs_count_in_state += 1
	print(dialogs_count_in_state)
	
func say_line(l):
	get_node("dialog").set_text(l)
	var number_of_spaces = l.split(" ").size()
	var time_line = l.length() * 0.4 / number_of_spaces
	timerDialog.set_wait_time(time_line)
	timerDialog.start()

