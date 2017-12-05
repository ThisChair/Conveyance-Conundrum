extends "delegated_behavior.gd"

# Variables
onready var raycast_query = get_node("/root/level/pathfollowing box/RayCast2D/")
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
	
	# Add an exception so that it doesn't collide with it's own collider
	raycast_query.add_exception(get_parent())
	
	if not path.empty():
		# Instantiation of new path following class
		var path_follow = FollowPath.new(get_node("/root/level/pathfollowing box/"),path,null)
		# Calculate the new blended steering and give it to the parent
		get_parent().steering = path_follow.getSteering()	

	# Instantiation of new obstacle avoidance class
	#var avoid = ObstacleAvoidance.new(get_parent(),raycast_query)
	
	# List of steering behaviors with weights
	#var b1 = BehaviorAndWeight.new(path_follow,1)
	#var b2 = BehaviorAndWeight.new(avoid,1)
	#var behaviors_list = [b1,b2]
	
	# Instantiation of new blended steering class
	#var blended_steer = BlendedSteering.new(behaviors_list)
	
	
	
func _input(event):
	# Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON):
		# On mouse click, get click position
		var initial = graph_node.findTriangle(get_global_pos())
		var final = graph_node.findTriangle(event.pos)
		path = graph_node.optimalPath(initial,final)
