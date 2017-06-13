tool
extends GraphNode

var id setget set_id,get_id
# Type of node
var type setget set_type,get_type
# path to scene used to create new blocks
var block_scene setget set_block_scene,get_block_scene
# Is new block collapsed on creation?
export(bool) var new_block_collapsed

# Left/right slots of first block
export(bool) var first_left_slot
export(bool) var first_right_slot
# Does a new block add new slots (left/right)?
export(bool) var new_block_adds_left_slot
export(bool) var new_block_adds_right_slot
# Left/right slots types for blocks
export(int,9) var left_slot_type = 0
export(int,9) var right_slot_type = 0

var typecol = [Color(1,1,1), Color(0.9, 0.4, 1), Color(0.8, 1, 0.2), Color(1, 0.2, 0.2), Color(0, 1, 1)]

## BLOCKS VARS
onready var nb_blocks = 0
onready var nodes_blocks = []
onready var free_ids = []
onready var max_id_blocks = 0



func _ready():
	# security
	if (new_block_collapsed == null):
		new_block_collapsed = false
	if (first_left_slot == null):
		first_left_slot = true
	if (first_right_slot == null):
		first_right_slot = true
	if (new_block_adds_left_slot == null):
		new_block_adds_left_slot = false
	if (new_block_adds_right_slot == null):
		new_block_adds_right_slot = false

	if (not is_connected("close_request", self, "_on_close_request")):
		connect("close_request", self, "_on_close_request")
		
	connect("raise_request", self, "_on_raise_request", [self])

func _on_raise_request(raised_node):
	print(get_name())
	pass

func set_type(new):
	type = new
	
func get_type():
	return type
	
func set_id(new):
	id = new
	
func get_id():
	return id

func set_block_scene(new):
	block_scene = new
	
func get_block_scene():
	return block_scene

###########################################
###########################################

# Default Save node function. Basically, saves global data of the node 
# and gets the data of each block contained in the node to JSON format.
# Must be overriden in the node script if it needs specific save.
func save_data(node_list):
	var nodeDict = {
			"type": self.type,
			"id": get_name(),
			"x": get_offset().x,
			"y": get_offset().y,
			"nb_blocks": nb_blocks
			}
	for i in range(0, nb_blocks):
		var block = nodes_blocks[i]
		nodeDict["data"+str(block.get_id())] = block.get_data()
		
	node_list.push_back(nodeDict)

# Default Load function (from json string)
# Does nothing, needs to be overriden in the node script.
func load_data(json_data):
	print("INFO: Default load_data() method called. This method does nothing and needs to be overriden.")
	pass


###########################################
###########################################

# delete GraphNode on close request
func _on_close_request():
	queue_free()

# instance a scene to add as a block in the GraphNode.
func add_new_block():
	var block = load(block_scene).instance()
	
	# Set a free id if there is
	if !free_ids.empty():
		block.set_id(free_ids[0])
		free_ids.remove(0)
	else:
		block.set_id(nb_blocks)
	
	if block.id > max_id_blocks:
		max_id_blocks = block.id
	
	add_rembutton(block)
	if (nb_blocks+1 <= 1):
		hide_rembutton(block)
	
	# add the '+' button to add new blocks into this block
	add_addbutton(block)
	
	add_child(block)
	
	# add this block to the blocks list
	nodes_blocks.append(block)
	
	nb_blocks += 1
	
	# at least 2 variables, add remove button to first variable so it can be deleted
	if (nb_blocks > 1):
		show_rembutton(nodes_blocks[0])
	
	# enable/disable slots of the GraphNode for this block EXCEPT BLOCK 1
	if (nb_blocks == 1):
		#print("FIRST BLOCK", str(first_left_slot), str(first_right_slot))
		set_slot(nb_blocks-1, first_left_slot, left_slot_type, typecol[left_slot_type], first_right_slot, right_slot_type, typecol[right_slot_type])
	else:
		#print("NEW BLOCK", str(new_block_adds_left_slot), str(new_block_adds_right_slot))
		set_slot(nb_blocks-1, new_block_adds_left_slot, left_slot_type, typecol[left_slot_type], new_block_adds_right_slot, right_slot_type, typecol[right_slot_type])
	
	if (new_block_collapsed && block.block_to_collapse != null):
		block._on_collapse_block_pressed()
	
	# do we need sorting the blocks? If the last id entered is != nb_blocks, then yes we do.
	if block.id != nb_blocks:
		sort_blocks()
		
	return block

# adds by script the "+" button to add an action block to the graphnode
func add_addbutton(block):
	var btnAdd = Button.new()
	btnAdd.set_name("addbtn")
	btnAdd.set_text("+")
	btnAdd.connect("pressed", self, "_on_add_pressed")
	block.get_node("hbox").add_child(btnAdd)
	
# adds by script the "-" button to remove the action block from the graphnode
func add_rembutton(block):
	var btnRemove = Button.new()
	btnRemove.set_name("rembtn")
	btnRemove.set_text("-")
	#print(parent)
	btnRemove.connect("pressed", self, "_on_remove_pressed", [block])
	block.get_node("hbox").add_child(btnRemove)

# hide the "-" button
func hide_rembutton(block):
	block.get_node("hbox/rembtn").hide()
	
# display the "-" button
func show_rembutton(block):
	block.get_node("hbox/rembtn").show()

# Add block button pressed
func _on_add_pressed():
	add_new_block()

# Remove block button pressed
func _on_remove_pressed(block):
	
	# if block to be removed is not the last one created, we add its id to the free_ids list
	if block.id < max_id_blocks+1:
		free_ids.append(block.id)
		free_ids.sort()

	remove_child(block)
	nodes_blocks.remove( nodes_blocks.find(block) )
	nb_blocks -= 1
	
	if nb_blocks == 1:
		hide_rembutton(nodes_blocks[0])
	
	var resize = get_minimum_size()
	set_size( Vector2(resize.x, 0 ) )


func clear_blocks():
	for block in nodes_blocks:
		_on_remove_pressed(block)
	nodes_blocks.clear()
	nb_blocks = 0

# This function sorts the blocks according to their ids.
func sort_blocks():
	var blocks_list = []
	var blocks_list_unsorted = []
	
	for b in get_children():
		blocks_list.append(b)
		blocks_list_unsorted.append(b)
		remove_child(b)
		
	blocks_list.sort_custom(self, "sort_ids")
	
	for b in blocks_list:
		add_child(b)


func sort_ids(blockA, blockB):
	return blockA.id < blockB.id