extends "delegated_behavior.gd"

# Variables
var space_state
var raycast_query
var cast_direction = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	space_state = get_world_2d().get_direct_space_state()
	cast_direction = Vector2(sin(get_parent().orientation),cos(get_parent().orientation))
	cast_direction.normalized()
	cast_direction *= 50
	raycast_query = space_state.intersect_ray(get_parent().get_global_pos(),cast_direction,[get_parent()])
	print("global start:"+str(get_parent().get_global_pos())+", global finish:"+str(cast_direction))
	
	# Instantiation of new seek class
	var seek = RadiusSeek.new(get_parent(),get_node("/root/level/player"))
	
	# Instantiation of new obstacle avoidance class
	var obs_avoid = ObstacleAvoidance.new(get_parent(),raycast_query)
	
	# List of steering behaviors with weights
	var b1 = BehaviorAndWeight.new(seek,0)
	var b2 = BehaviorAndWeight.new(obs_avoid,1)
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
	
	
