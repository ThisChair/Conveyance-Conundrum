extends "delegated_behavior.gd"

# Variables
var graph_node
var path = []
var sound_graph
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Get the graph representing the map
	graph_node = get_parent().get_parent().get_node("/root/Demo/level graph/")
	sound_graph = get_parent().get_parent().get_node("/root/Demo/sound/")
#	var initial = graph_node.findTriangle(get_global_pos())
	# And from there, the optimal path given by A*
#	path = graph_node.optimalPath(initial,42)
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	
	# Instantiation of new path following class
	var path_follow = FollowPath.new(get_node("/root/Demo/human/"),path,null)
	# Calculate the new blended steering and give it to the parent
	get_parent().steering = path_follow.getSteering()	
	
func _input(event):
	# Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON):
		# On mouse click, get click position
		var initial = graph_node.findTriangle(get_global_pos())
		var final = graph_node.findTriangle(get_global_mouse_pos())
		path = graph_node.optimalPath(initial,final)
	if (event.type==InputEvent.KEY):
		if event.scancode==KEY_Q:
			get_parent().get_node("SamplePlayer2D").play("signal")
			var friends = get_tree().get_nodes_in_group("friendly")
			for f in friends:
				var initial = sound_graph.findTriangle(get_global_pos())
				var final = sound_graph.findTriangle(f.get_global_pos())
				if sound_graph.optimalCost(initial,final) < 800:
					f.get_node("BuddyCalls").called = true
		if event.scancode==KEY_W:
			get_parent().get_node("SamplePlayer2D").play("signal")
			var friends = get_tree().get_nodes_in_group("friendly")
			print("KEY  W PRESSED")
			for f in friends:
				var initial = sound_graph.findTriangle(get_global_pos())
				var final = sound_graph.findTriangle(f.get_global_pos())
				if sound_graph.optimalCost(initial,final) < 800:
					f.get_node("BuddyCalls").follow = true
		if event.scancode==KEY_E:
			get_parent().get_node("SamplePlayer2D").play("signal")
			var friends = get_tree().get_nodes_in_group("friendly")
			for f in friends:
				var initial = sound_graph.findTriangle(get_global_pos())
				var final = sound_graph.findTriangle(f.get_global_pos())
				if sound_graph.optimalCost(initial,final) < 800:
					f.get_node("BuddyCalls").explore = true
