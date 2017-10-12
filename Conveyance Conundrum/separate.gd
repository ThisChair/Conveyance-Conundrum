extends "behavior.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	
	# List of targets
	var targets = [get_node("/root/level/player")]
	# Instantiation of new separate class
	var separate = Separation.new(get_parent(),targets)
	
	# Calculate the new steering and give it to the parent
	get_parent().steering = separate.getSteering()