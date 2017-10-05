extends Node2D

# Class for manually updating the character's attributes

class SteeringBehavior:
	var velocity = Vector2(0,0)
	var rotation = 0.0
	var linear = Vector2(0,0)
	var angular= 0
	
	# Function that adds two steerings.
	func add_steering(steer):
		self.velocity += steer.velocity
		self.rotation += steer.rotation
		self.linear += steer.linear
		self.angular += steer.angular
		

export(float) var maxSpeed = 55
var position = self.get_pos()
var orientation = self.get_rot()
var steering = SteeringBehavior.new()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# Update character position and orientation
	position += steering.velocity * delta
	orientation += steering.rotation * delta
	
	# and the velocity and rotation
	steering.velocity += steering.linear * delta
	steering.rotation += steering.angular * delta
	
	# limit speed
	if ((steering.velocity.length() > maxSpeed) and 
		(steering.linear.length() != 0)):
		steering.velocity = steering.velocity.normalized()
		steering.velocity *= maxSpeed
		
	set_pos(position)
	set_rot(orientation)
