extends "behavior.gd"

var seekPoint = Node2D.new()
var center = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	seekPoint.set_pos(center)
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	
	# Get the list of flocking agents from the Flock parent node
	var flockNode = get_parent().get_parent()
	var agentList = flockNode.agentList
	
	var flock = Flocking.new(get_parent(),agentList)
	#var seek = Seek.new(get_parent(),seekPoint)
	
	#var b1 = BehaviorAndWeight.new(flock,1)
	#var b2 = BehaviorAndWeight.new(seek,1)
	#var behaviors_list = [b1,b2]
	
	#var blended_steer = BlendedSteering.new(behaviors_list)
	
	#get_parent().steering = blended_steer.getSteering()
	get_parent().steering = flock.getSteering()
	
func _input(event):
	# Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON):
		seekPoint.set_pos(event.pos)