
onready var timer = Timer.new()
onready var timerDialog = Timer.new()
onready var current_counter = 0

signal dialog_node_finished

var dialogsList

func _ready():
	add_child(timer)
	
	timerDialog.connect("timeout", self, "display_dialogs_list")
	add_child(timerDialog)
	
	connect("dialog_node_finished", self, "execute_dialog")

func execute_dialog():
	var nodesList = get_node("TreeNode").execute()
	print("NODES LIST")
	print(nodesList)

	var node = nodesList[0]
	print("NODE:")
	print(node)
	
	if node.type == "dialog_line":
		dialogsList = node.data0.dialog.split("\n")
		display_dialogs_list()
		
	elif node.type == "dialog_option":
		var optionsList = []
		for i in range(0, node.nb_blocks):
			optionsList.append(node["data"+str(i)])
		print("OPTIONS LIST")
		print(optionsList)
			

func display_dialogs_list():
	if (current_counter == dialogsList.size()):
		get_node("dialog").set_text("")
		emit_signal("dialog_node_finished")
		print("SIGNAL EMITTED")
		return
		
	get_node("dialog").set_text(dialogsList[current_counter])
	var number_of_spaces = dialogsList[current_counter].split(" ").size()
	var time_line = dialogsList[current_counter].length() * 0.4 / number_of_spaces
	print(time_line)
	timerDialog.set_wait_time(time_line)
	current_counter += 1
	timerDialog.start()