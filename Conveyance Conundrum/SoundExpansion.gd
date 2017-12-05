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
	
	#print(paths[0].size())
	#print(paths[1].size())
	if (Input.is_action_pressed("ui_select")):
		get_node("SamplePlayer2D").play("signal")
		var receptors = []
		if paths[0].size() < 8:
			receptors.append(
				get_parent().get_node("/root/level/Receptor1/")
			)
		if paths[1].size() < 8:
			receptors.append(
				get_parent().get_node("/root/level/Receptor2/")
			)
		for receptor in receptors:
			receptor.set_texture(load("res://bomba_ANGERY.png"))