extends KinematicBody2D

# Constants
const GRAVITY = 20
const WALK_SPEED = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	#velocity.y += GRAVITY * delta
	var character_pos = get_pos()
	var target_pos = get_parent().get_node("playerbox").get_pos()
	var character_orient = get_rot()
	
	var instanced_seek = KinematicSeek.new()
	var new_movement = instanced_seek.getSteering(character_pos,target_pos,character_orient)
	var motion = new_movement[0] * delta
	move(motion)
	# Face in the direction we want to move
	set_rot(new_movement[1])
	
class KinematicSeek:
	
	# Maximum speed the character can travel
	var MAX_SPEED = 1
	
	func getNewOrientation(currentOrientation,velocity):
	
		# Make sure we have velocity
		if velocity.length() > 0:
			# Calculate orientation using an arc tangent of the velocity components
			return velocity.angle()
		# Otherwise use the current orientation
		return currentOrientation
	
	func getSteering(character_pos,target_pos,character_orient):
		
		# Get the direction to the target
		var steering_velocity = character_pos - target_pos
		
		# The velocity is along this direction, at full speed
		steering_velocity.normalized()
		steering_velocity *= MAX_SPEED
		
		# Calculate new orientation
		var character_orient = getNewOrientation(character_orient,steering_velocity)
		
		var movement = [steering_velocity,character_orient]
		return movement
