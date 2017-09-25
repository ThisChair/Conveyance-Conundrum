extends KinematicBody2D

# Constants
const GRAVITY = 20
const WALK_SPEED = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	var character_pos = get_pos()
	var target_pos = get_parent().get_node("playerbox").get_pos()
	var character_orient = get_rot()
	
	var instanced_seek = KinematicSeek.new()
	var new_movement = instanced_seek.getSteering(character_pos,target_pos,character_orient)
	if (new_movement == null):
		pass
	else:
		var motion = new_movement[0] * delta
		move(motion)
		# Face in the direction we want to move
		set_rot(new_movement[1]) 
	
class KinematicSeek:
	
	# Maximum speed the character can travel
	var MAX_SPEED = 1
	
	# Satisfaction radius
	var radius = 100
	
	# Time to target constant
	var timeToTarget = 3
	
	func getNewOrientation(currentOrientation,velocity):
	
		# Make sure we have velocity
		if velocity.length() > 0:
			# Calculate orientation using an arc tangent of the velocity components
			return velocity.angle()
		# Otherwise use the current orientation
		return currentOrientation
	
	func getSteering(character_pos,target_pos,character_orient):
		
		# Get the direction to the target
		var steering_velocity = target_pos - character_pos
		
		# Check if we're within radius
		if (steering_velocity.length() < radius):
			return null
			
		# Move to target in timeToTarget seconds
		steering_velocity /= timeToTarget
		
		# If it's too fast, cap it to the max speed
		if (steering_velocity.length() > MAX_SPEED):
			steering_velocity.normalized()
			steering_velocity *= MAX_SPEED
		
		# Face in the direction we want to move
		var character_orient = getNewOrientation(character_orient,steering_velocity)
		
		var movement = [steering_velocity,character_orient]
		return movement
