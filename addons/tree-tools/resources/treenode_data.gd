tool
extends Resource

const META_EXTENSION = "json"

# Dictionary of lines in this dialog including their translations
# Key = id of the dialog line
#var example = {
#		1: {
#			"fr": "Coi oublieux.",
#			"en": "Coi forgetter."
#		}
#	}
var dialog_lines_translations = {}

# List of connections between nodes, as given by GraphEdit.get_connections_list()
var connections_list = []

# List of graphnodes objects
var graphnodes_list = []
