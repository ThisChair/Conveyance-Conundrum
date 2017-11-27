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
	
	# Function to set a steering to 0
	func nullify():
		self.velocity = Vector2(0,0)
		self.rotation = 0.0
		self.linear = Vector2(0,0)
		self.angular = 0
		

class Flight:
	var velocity = 0.0
	var acceleration = 0.0
	var state_jump = false
	var state_fall = false
	var original_scale
	var original_z
	var plane_vel = 0.0
	export(float) var gravity = 3.0


export(float) var maxSpeed = 50
var position = self.get_pos()
var orientation = self.get_rot()
var steering = SteeringBehavior.new()
var flight = Flight.new()
var motion 

func _ready():
	flight.original_scale = self.get_scale()
	flight.original_z = self.get_z()
	set_fixed_process(true)

func _fixed_process(delta):
	
	position = self.get_pos()
	orientation = self.get_rot()
	
	# Update character position and orientation
	orientation += steering.rotation * delta
	if flight.state_fall or flight.state_jump:
		steering.velocity = flight.plane_vel
		set_rot(orientation)
		
	position += steering.velocity * delta
	motion = steering.velocity * delta
	
	move(motion)
	
	
	# Slide on terrain collisions
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		steering.velocity = n.slide(steering.velocity)
		move(motion)
	
	# and the velocity and rotation
	steering.velocity += steering.linear * delta
	steering.rotation += steering.angular * delta
	
	# limit speed
	if ((steering.velocity.length() > maxSpeed) and (steering.linear.length() != 0)):
		steering.velocity = steering.velocity.normalized()
		steering.velocity *= maxSpeed

	# Flight data
	var actual_scale = get_scale()
	if flight.state_fall or flight.state_jump:
		flight.velocity += (flight.acceleration - flight.gravity) * delta
		var new_scale = actual_scale + Vector2(1,1) * flight.velocity * delta
		if new_scale > flight.original_scale * 1.5:
			new_scale = flight.original_scale * 1.5
		set_scale(new_scale)
	if flight.velocity > 0 and not flight.state_fall:
		flight.plane_vel = steering.velocity
		flight.state_jump = true
		set_z(flight.original_z + 100)
	if flight.state_jump:
		if flight.velocity < 0.0:
			flight.state_fall = true
			flight.state_jump = false
	elif flight.state_fall:
		if (actual_scale < flight.original_scale):
			flight.velocity = 0.0
			flight.state_fall = false
			flight.acceleration = 0.0
			set_scale(flight.original_scale)
			set_z(flight.original_z)