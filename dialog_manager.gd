

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_run_dlg_1_pressed():
	var nodesList = get_node("TreeNode").execute()
	print("NODES LIST")
	print(nodesList)
	
	if nodesList.size() > 1:	
		print("There must be a problem?")
		pass 
	else:
		var node = nodesList[0]
		print("NODE:")
		print(node)
		if node.type == "dialog_line":
			get_node("dialog").set_text(node.data0.dialog)
		elif node.type == "dialog_option":
			var optionsList = []
			for i in range(0, node.nb_blocks):
				optionsList.append(node["data"+str(i)])
			print("OPTIONS LIST")
			print(optionsList)
			
