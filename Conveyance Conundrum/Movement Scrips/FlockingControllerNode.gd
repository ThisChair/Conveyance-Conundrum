extends Node2D

# Variables
var agentList = []
# Iterator
var i = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var child
	# Find all the flocking agents and add them to the 
	# agents list
	while (i < get_child_count()):
		
		# Iterate over all childen nodes
		child = get_child(i)
		agentList.append(child)
		i += 1
		
	# Our work here is done