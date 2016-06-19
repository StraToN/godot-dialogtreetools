
extends Node2D

# PARAMETRES
export(String, FILE) var dialogFile
export(Color) var colorText
var player

## GLOBAL
var listNodes
var listConnexions
var iterations = 0

# STATEMENT MANAGEMENT
var operands = { "not":"!",
				 "==":["is","eq"],
				 "!=":"neq"}
var delimiters = {"and":"&&",
				  "or":"||" }
var bools = { "true":"1",
			  "false":"0" }
var listVariablesStatement = []
var listValuesStatement = []
var listOperatorsStatement = []



## DATA DIALOG
var actorName		# name of NPC
var lines			# list of dialog lines in the current node
var currentIdLine	# current ID of line to be said
var anim
var statement
var variablesList = { "in_dialog":"false"}

## OPTIONS DIALOGS
var listOptions = []

## DONNEES INTERNES
var currentNode 
var isCurrentNodeFinished
var currentConnexions = []
var nextNodes = []
var chrono

func _ready():
	player = get_parent().get_node("player")
	
	var font = preload("res://DialogTester/fonts/TitilliumWeb-Bold.fnt")
	
	var playerRTL = RichTextLabel.new()
	playerRTL.set("bbcode/enabled", true)
	playerRTL.set("custom_fonts/normal_font", "res://DialogTester/fonts/TitilliumWeb-Bold.fnt")
	playerRTL.set("custom_fonts/italic_font", font.get_path())
	playerRTL.set("custom_fonts/bold_font", font.get_path())
	playerRTL.set("custom_fonts/bold_italics_font", font.get_path())
	playerRTL.set("custom_colors/default_color", Color(1.0, 1.0, 1.0) )
	playerRTL.set_pos(player.get_node("dialogbox_pos").get_pos())
	playerRTL.set_size( Vector2(500,30))
	playerRTL.set_name("dialogbox")
	player.add_child(playerRTL)

	var dialogboxRTL = RichTextLabel.new()
	dialogboxRTL.set("bbcode/enabled", true)
	dialogboxRTL.set("custom_fonts/normal_font", font.get_path())
	dialogboxRTL.set("custom_fonts/italic_font", font.get_path())
	dialogboxRTL.set("custom_fonts/bold_font", font.get_path())
	dialogboxRTL.set("custom_fonts/bold_italics_font", font.get_path())
	dialogboxRTL.set("custom_colors/default_color", colorText )
	dialogboxRTL.set_pos(get_node("dialogbox_pos").get_pos())
	dialogboxRTL.set_size( Vector2(500, 30))
	dialogboxRTL.set_name("dialogbox")
	self.add_child(dialogboxRTL)

	
	
	var file = File.new()
	file.open(dialogFile, file.READ)
	var jsonString = file.get_as_text()
	file.close()
	
	chrono = Timer.new()
	chrono.set_wait_time(1.5)
	chrono.connect("timeout", self, "dialogTimeout")
	add_child(chrono)
	
	#var jsonString = '{"connections":[{"to":"node2", "from":"node1", "to_port":0, "from_port":0}], '
	#jsonString += '"nodes":[{"id":"node1", "x":524, "name":"start", "y":429.5, "type":"startnode"}, '
	#jsonString += '{"lines0":"%25Salut%20%21%0aBonjour.%0a%25Je%20suis%20content%20de%20te%20rencontrer.%20%0aEt%20vous%20%c3%aates%20%3f%0aD%c3%a9sol%c3%a9.%20Je%20n%27ai%20pas%20le%20temps%20de%20discuter%20avec%20vous.", '
		#jsonString += '"hidden0":false, "anim0":"", "id":"node2", "x":743, "y":313, "type":"dialog_line"}]}'
	
	#var jsonString = '{"connections":[{"to":"node2", "from":"node1", "to_port":0, "from_port":0}, '
	#jsonString += '{"to":"node3", "from":"node2", "to_port":0, "from_port":0}],' 
	#jsonString += '"nodes":[{"id":"node1", "x":524, "name":"start", "y":429.5, "type":"startnode"}, '
	#jsonString += '{"lines0":"%25Salut%20%21%0aBonjour.%0a%25Je%20suis%20content%20de%20te%20rencontrer.%20%0aEt%20vous%20%c3%aates%20%3f%0aD%c3%a9sol%c3%a9.%20Je%20n%27ai%20pas%20le%20temps%20de%20discuter%20avec%20vous.", "hidden0":false, "anim0":"", "id":"node2", "x":743, "y":313, "type":"dialog_line"}, '
	#jsonString +='{"lines0":"%25Mh.%20Pas%20tr%c3%a8s%20sympa.", "hidden0":false, "anim0":"", "id":"node3", "x":1120, "y":301, "type":"dialog_line"}]}'
	
	
	var dictJson = {}
	dictJson.parse_json(jsonString)
	
	listNodes = dictJson["nodes"]
	print(listNodes)
	listConnexions = dictJson["connections"]
	
	nextNodes = ["node1"]
	isCurrentNodeFinished = true
	set_process(true)


func _process(delta):
	get_parent().get_node("currentnode_finished").set_text("Current Node finished? "+ str(isCurrentNodeFinished))
	if (isCurrentNodeFinished):
		if (nextNodes.size() == 1):
			execute(nextNodes[0])
		else: # multiple nodes !
			execute("options")


#####################

func execute(nodeName):
	
	isCurrentNodeFinished = false
	print(nodeName)
	
	if (nodeName != "options"):
		currentNode = get_node_from_list(nodeName)
		currentConnexions = get_connexions_from_list(nodeName)
	
		printt("Current", currentNode)
		printt("Connexions", currentConnexions)
		print()
	else:
		currentNode = listOptions[0]
	
	# process current node
	if currentNode.type == "startnode":
		actorName = currentNode.name
		isCurrentNodeFinished = true
	elif currentNode.type == "dialog_line":
		lines = currentNode.lines0.percent_decode().split("\n")
		anim = currentNode.anim0

		# display first line of dialog
		displayLine(0)
		
		currentIdLine = 1
		chrono.start()
		
	elif currentNode.type == "dialog_option":
		printt("LISTE OPTIONS : ", listOptions)
		var optionsLabelsYdecal = 0
		for optionNode in listOptions:
			var label = RichTextLabel.new()
			label.connect("input_event", self, "on_dialog_option_focus")

			label.set_bbcode(optionNode.lines.percent_decode())
			
			label.set_size( Vector2(1450,30))
			label.set_pos( Vector2(0, optionsLabelsYdecal))
			label.set("custom_fonts/normal_font", "res://DialogTester/fonts/TitilliumWeb-Bold.fnt")
			get_parent().get_node("OptionsPanel").add_child(label)
			#label.set_hidden(false)
			optionsLabelsYdecal += 40
		
		
		#set_process_input(true)
		isCurrentNodeFinished = false
		
	elif currentNode.type == "dialog_condition":
		statement = currentNode.statement
		parse_statement(statement)
		isCurrentNodeFinished = true
	
	# calcul nexts
	nextNodes.clear()
	#var nbChildren = currentConnexions.size()
	for c in currentConnexions:
		nextNodes.append( c.to )
	printt("NEXT NODES = ", nextNodes)
	
	if (nextNodes.size() > 1): # OPTIONS !
		parseOptions(nextNodes)
		
	print("==================")


func parseOptions(listOptionsNodesNames):
	listOptions.clear()
	printt("listOptionsNodesNames ", listOptionsNodesNames)
	for optionsNodesNames in listOptionsNodesNames:
		listOptions.append(get_node_from_list(optionsNodesNames))
	print(listOptions)

func get_node_from_list(nodeName):
	for n in listNodes:
		if n["id"] == nodeName:
			return n


func get_connexions_from_list(nodeName):
	var connexions = []
	for c in listConnexions:
		if c["from"] == nodeName:
			connexions.append(c)
	return connexions
	
	
func dialogTimeout():
	get_parent().get_node("chrono_currentLine").set_text("Current ID line : " + str(currentIdLine))
	
	if (currentIdLine == lines.size()): # last line of the dialog
		chrono.stop()
		player.get_node("dialogbox").set_bbcode("")
		get_node("dialogbox").set_bbcode("")
		if (get_node("anim").is_playing()):
			get_node("anim").stop()
		if (player.get_node("anim").is_playing()):
			player.get_node("anim").stop()
		currentIdLine = 0
		isCurrentNodeFinished = true
		
	else:
		displayLine(currentIdLine)
		currentIdLine += 1
		
		
func displayLine(lineId):
	if (lines[lineId][0] == "%"):
		player.get_node("dialogbox").set_bbcode( lines[lineId] )
		player.get_node("anim").play("talk")
		get_node("dialogbox").set_bbcode("")
		if (get_node("anim").is_playing()):
			get_node("anim").stop()
	else:
		get_node("dialogbox").set_bbcode( lines[lineId] )
		get_node("anim").play("talk")
		player.get_node("dialogbox").set_bbcode("")
		if (player.get_node("anim").is_playing()):
			player.get_node("anim").stop()

func on_dialog_option_focus():
	print("event")

############
# STATEMENT
############

# iVar == 5 && not bVar || "pouet" == sVar
# iVar -> variables
# == -> operators
# 5 -> values
# && -> operators CHANGE
# not -> operators
# bVar -> variables
# || -> operators CHANGE
# "pouet" -> values
# == -> operators
# sVar -> variables
#
# operators : == && not || ==
# variables : iVar bVar sVar
# values    : 5 "pouet"
#
# sVar == "pouet"
# ||
# bVar not
# &&
# iVar == 5

# eval equivalent
func parse_statement(statement):
	var elements = statement.split(" ")
	
	for e in elements:
		if is_statement_operand(e):
			listOperatorsStatement.push_back(e)
		elif is_statement_bool(e) or e.is_valid_integer() or e.is_valid_float():
			listValuesStatement.push_back(e)
		else:
			listVariablesStatement.push_back(e)
	
	printt(listOperatorsStatement, listValuesStatement, listVariablesStatement)
	var nbVar = listVariablesStatement.size()
	for i in range(0, nbVar):
		var variable = listVariablesStatement[i]
		var operator = listOperatorsStatement[i]
		while is_statement_operand(operator):
			operator = listOperatorsStatement[i]
		
	
			
func is_statement_operand(s):
	return operands.has(s)

func is_statement_bool(s):
	return bools.has(s)
	