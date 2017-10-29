extends "delegated_behavior.gd"

# Variables
onready var raycast_query = get_node("/root/level/pathfollowing box/RayCast2D/")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Add an exception so that it doesn't collide with it's own collider
	raycast_query.add_exception(get_parent())
	
	# Get the graph representing the map
	var graph_node = get_parent().get_node("/root/level/geometry graph/")
	
	# And from there, the optimal path given by A*
	var path = graph_node.optimal_path
	
	# Instantiation of new path following class
	var path_follow = FollowPath.new(get_node("/root/level/pathfollowing box/"),path,true)
	
	# Instantiation of new obstacle avoidance class
	var avoid = ObstacleAvoidance.new(get_parent(),raycast_query)
	
	# List of steering behaviors with weights
	var b1 = BehaviorAndWeight.new(path_follow,1)
	var b2 = BehaviorAndWeight.new(avoid,1)
	var behaviors_list = [b1,b2]
	
	# Instantiation of new blended steering class
	var blended_steer = BlendedSteering.new(behaviors_list)
	
	# Calculate the new blended steering and give it to the parent
	get_parent().steering = blended_steer.getSteering()