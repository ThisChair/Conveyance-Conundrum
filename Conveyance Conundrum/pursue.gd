extends "delegated_behavior.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Instantiation of new pursue class
	var seek = Seek.new(get_parent(),get_node("/root/level/player"))
	var pursue = Pursue.new(seek)
	get_parent().steering = pursue.getSteering()
