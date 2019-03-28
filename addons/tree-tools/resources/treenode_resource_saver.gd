tool
class_name TreeNodeDataSaver
extends ResourceFormatSaver


const TreeNodeData = preload("res://addons/tree-tools/resources/treenode_data.gd")


func get_recognized_extensions(res):
	if res != null and res is TreeNodeData:
		return PoolStringArray([TreeNodeData.META_EXTENSION])
	return PoolStringArray()


func recognize(res):
	return res is TreeNodeData


func save(path, resource, flags):
	resource.save_data(path.get_base_dir())