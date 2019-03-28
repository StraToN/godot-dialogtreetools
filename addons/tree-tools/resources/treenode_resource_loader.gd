tool
class_name TreenNodeDataLoader
extends ResourceFormatLoader

const TreeNodeData = preload("treenode_data.gd")

func get_recognized_extensions():
	return PoolStringArray([TreeNodeData.META_EXTENSION])


func get_resource_type(path):
	var ext = path.get_extension().to_lower()
	if ext == TreeNodeData.META_EXTENSION:
		return "Resource"
	return ""


func handles_type(typename):
	return typename == "Resource"


func load(path, original_path):
	var res = TreeNodeData.new()
	res.load_data(path.get_base_dir())
	return res