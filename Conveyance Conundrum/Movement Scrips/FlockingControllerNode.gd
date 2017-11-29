extends Node2D

# Variables
var agentList = []
var seekPoint = Vector2()
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
	set_process_input(true)
	
func _input(event):
	# Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON):
		# On mouse click, get click position
		seekPoint = event.pos