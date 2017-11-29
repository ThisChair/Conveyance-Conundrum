extends Node2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Get the graph representing the map
	var graph_node = get_parent().get_node("/root/level/sound graph/")
	
	# And from there, the optimal path given by A*
	var paths = graph_node.optimal_path
	var cost
	for path in paths:
		cost = 0
		for edge in path:
			cost += edge[1]