extends "behavior.gd"

# Variables
var pos

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	
	# Get the list of flocking agents from the Flock parent node
	var flockNode = get_parent().get_parent()
	var agentList = flockNode.agentList
	# Also get the seeking point
	var pos = flockNode.seekPoint
	
	# Instantiation of new flock class
	var flock = Flocking.new(pos,get_parent(),agentList)
	
	get_parent().steering = flock.getSteering()
