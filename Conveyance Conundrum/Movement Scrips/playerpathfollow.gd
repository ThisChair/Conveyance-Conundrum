extends "delegated_behavior.gd"

# Variables
var graph_node
var path = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Get the graph representing the map
	graph_node = get_parent().get_node("/root/level/level graph/")
#	var initial = graph_node.findTriangle(get_global_pos())
	# And from there, the optimal path given by A*
#	path = graph_node.optimalPath(initial,42)
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	
	# Instantiation of new path following class
	var path_follow = FollowPath.new(get_node("/root/level/human/"),path,null)
	# Calculate the new blended steering and give it to the parent
	get_parent().steering = path_follow.getSteering()	
	
func _input(event):
	# Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON):
		# On mouse click, get click position
		var initial = graph_node.findTriangle(get_global_pos())
		var final = graph_node.findTriangle(event.pos)
		path = graph_node.optimalPath(initial,final)
