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
		

class Flight:
	var force = 0.0
	var state_jump = false
	var state_fall = false
	var original_scale
	var original_z

export(float) var maxSpeed = 55
var position = self.get_pos()
var orientation = self.get_rot()
var steering = SteeringBehavior.new()
var flight = Flight.new()

func _ready():
	flight.original_scale = self.get_scale()
	flight.original_z = self.get_z()
	set_fixed_process(true)

func _fixed_process(delta):
	
	position = self.get_pos()
	orientation = self.get_rot()
	
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
	
	# Flight data
	if flight.force > 0 and not flight.state_fall:
		flight.state_jump = true
		set_z(flight.original_z * 2)
	var actual_scale = get_scale()
	if flight.state_jump:
		set_scale(actual_scale + flight.original_scale/(20 * flight.force))
		if actual_scale >= flight.original_scale * flight.force:
			flight.state_fall = true
			flight.state_jump = false
			set_scale(flight.original_scale * flight.force)
	else:
		if (actual_scale > flight.original_scale):
			set_scale(actual_scale - flight.original_scale/(30 * flight.force))
		if (actual_scale < flight.original_scale):
			set_scale(flight.original_scale)
			set_z(flight.original_z)
			flight.state_fall = false
			flight.force = 0
