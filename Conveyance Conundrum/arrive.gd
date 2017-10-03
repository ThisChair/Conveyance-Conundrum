extends "behavior.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(false)
	
func _fixed_process(delta):
	
	# Instantiation of new arrive class
	var arrive = Arrive.new(get_parent(),get_node("/root/level/player"))
	
	# Calculate the new steering and give it to the parent 
	get_parent().steering = arrive.getSteering()
