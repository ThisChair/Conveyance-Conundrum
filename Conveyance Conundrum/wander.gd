extends "behavior.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	
	# Instantiation of new kinematic wander class
	var wander = KinematicWander.new(get_parent())
	
	# Calculate the new steering and give it to the parent
	get_parent().steering = wander.getSteering()