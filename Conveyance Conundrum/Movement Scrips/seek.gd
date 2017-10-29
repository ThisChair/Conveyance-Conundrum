extends "delegated_behavior.gd"

# Variables
onready var raycast_query = get_node("/root/level/seeking box/RayCast2D/")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	raycast_query.add_exception(get_parent())
	
	# Instantiation of new seek class
	var seek = RadiusSeek.new(get_parent(),get_node("/root/level/player/"))
	
	# Instantiation of new obstacle avoidance class
	var obs_avoid = ObstacleAvoidance.new(get_parent(),raycast_query)
	
	# List of steering behaviors with weights
	var b1 = BehaviorAndWeight.new(seek,1)
	var b2 = BehaviorAndWeight.new(obs_avoid,1.5)
	var behaviors_list = [b1,b2]
	
	# Instantiation of new blended steering class
	var blended_steer = BlendedSteering.new(behaviors_list)
	
	# Calculate the new steering and give it to the parent
	var steering = blended_steer.getSteering()
	get_parent().steering = steering
	
	# Change the character sprite
	var sprite = get_node("/root/level/seeking box/Sprite")
	
	if (steering.velocity != Vector2(0,0)):
		sprite.set_texture(load("res://bomba_ANGERY.png"))
	else:
		sprite.set_texture(load("res://bomba.png"))	
	
	
