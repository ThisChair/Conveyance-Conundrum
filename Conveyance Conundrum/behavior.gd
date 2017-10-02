extends "kinematic.gd"

class KinematicSeek:
	
	# Character and target data
	var character
	var target
	
	# Maximum allowed speed
	export(float) var maxSpeed = 50
	
	# Function that returns the new orientation to face
	func getNewOrientation(currentOrientation, velocity):
		if velocity.length() > 0:
			return velocity.angle()
		else:
			return currentOrientation
	
	# Intialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	# Function that calculates and returns the wanted steering
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.velocity = target.get_pos() - character.get_pos()
		
		# Normalize and get to max speed
		steer.velocity = steer.velocity.normalized()
		steer.velocity *= maxSpeed
		
		# Face movement direction
		character.set_rot(getNewOrientation(character.orientation, steer.velocity))
		
		# We set the rotation to 0
		steer.rotation = 0
		
		return steer
		
class KinematicFlee:
	
	# Character and target data
	var character
	var target
	
	# Maximum allowed speed
	export(float) var maxSpeed = 50
	
	# Function that returns the new orientation to face
	func getNewOrientation(currentOrientation, velocity):
		if velocity.length() > 0:
			return velocity.angle()
		else:
			return currentOrientation
	
	# Initialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	# Function that calculates and returns the wanted steering
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.velocity = character.get_pos() - target.get_pos()
		
		# Normalize and get to max speed
		steer.velocity = steer.velocity.normalized()
		steer.velocity *= maxSpeed
		
		# Face movement direction
		character.set_rot(getNewOrientation(character.orientation, steer.velocity))
		
		# We set the rotation to 0
		steer.rotation = 0
		
		return steer
	
class KinematicArrive:
		
	# Character and target data
	var character
	var target
	
	# Maximum allowed speed
	export(float) var maxSpeed = 50
	
	# Satisfaction radius
	export(float) var radius = 200
	
	# Time to target
	
	var timeToTarget = 0.25
	
	# Initialization parameters for the class
	func _init(char,tar):
		self.character = char
		self.target = tar
		
	func getNewOrientation(currentOrientation,velocity):
		
		# Make sure we have velocity
		if velocity.length() > 0:
			# Calculate orientation using an arc tangent of the velocity components
			return velocity.angle()
			# Otherwise use the current orientation
		return currentOrientation
	
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.velocity = target.get_pos() - character.get_pos()
		
		# Check if we're within radius
		if (steer.velocity.length() < radius):
			character.set_rot(getNewOrientation(character.orientation,steer.velocity))
			steer.velocity = Vector2(0,0)
			steer.rotation = 0
			return steer
			
		# Move to target in timeToTarget seconds 
		steer.velocity /= timeToTarget
		
		# If it's too fast we cap it to the max speed
		if (steer.velocity.length() > maxSpeed):
			steer.velocity = steer.velocity.normalized()
			steer.velocity *= maxSpeed
			
		# Face in the direction we want to move 
		character.set_rot(getNewOrientation(character.orientation,steer.velocity))
		
		# We set the rotation to 0
		steer.rotation = 0
		
		return steer
	
class KinematicWander:
	
	# Character data
	var character
	
	# Maximum speed allowed
	export(float) var maxSpeed = 50
	
	# Maximum rotation we'd like, probably should be smaller than the maximum allowed
	export(float) var maxRot = 40
	
	# Initialization parameters for the class
	func _init(char):
		self.character = char
		
	# Function that returns a random number between [-1,1]
	func randomBinomial():
		return randi()%2 - randi()%2
	
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get velocity from the vector form of the orientation
		var dir = Vector2(sin(character.orientation), cos(character.orientation))
		steer.velocity = maxSpeed * dir
		
		# Change our orientation randomly
		steer.rotation = randomBinomial() * maxRot
		
		return steer

class Seek:
	# Character and target data
	var character
	var target
	
	# Maximum allowed acceleration
	export(float) var maxAcceleration = 50
	
	# Intialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	# Function that calculates and returns the wanted steering
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.linear = target.get_pos() - character.get_pos()
		
		# Normalize and get to max speed
		steer.linear = steer.linear.normalized()
		steer.linear *= maxAcceleration
		
		steer.velocity = character.steering.velocity
		
		return steer
		
class Flee:
	# Character and target data
	var character
	var target
	
	# Maximum allowed acceleration
	export(float) var maxAcceleration = 50
	
	# Intialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	# Function that calculates and returns the wanted steering
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.linear = character.get_pos() - target.get_pos()
		
		# Normalize and get to max speed
		steer.linear = steer.linear.normalized()
		steer.linear *= maxAcceleration
		
		steer.velocity = character.steering.velocity
		
		return steer
		
		
class Arrive:
	# Character and target data
	var character
	var target
	
	# Maximum allowed acceleration and speed
	export(float) var maxAcceleration = 50
	export(float) var maxSpeed = 50
	
	# Radius for arriving
	export(float) var targetRadius = 100
	
	# Radius for beginning to slow down
	export(float) var slowRadius = 200
	
	# Time to achieve speed
	export(float) var timeToTarget = 0.25
	
	# Intialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	# Function that calculates and returns the wanted steering
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction and distance to target
		var direction = target.get_pos() - character.get_pos()
		var distance = direction.length()
		
		# Check if we arrived already
		if distance < targetRadius:
			return steer
		
		var targetSpeed
		# MaxSpeed if outside slow radius
		if distance > slowRadius:
			targetSpeed = maxSpeed
		else:
			targetSpeed = maxSpeed * distance / slowRadius
			
		# Combine speed and direction
		var targetVelocity = direction
		targetVelocity = targetVelocity.normalized()
		targetVelocity *= targetSpeed
		
		# Try to reach target velocity
		steer.linear = targetVelocity - character.steering.velocity
		steer.linear /= timeToTarget
		
		# Clip acceleration
		if steer.linear.length() > maxAcceleration:
			steer.linear = steer.linear.normalized()
			steer.linear *= maxAcceleration
			
		# Output
		steer.velocity = character.steering.velocity
		
		return steer
		
class VelocityMatching:
	
	# Character and target data
	var character
	var target
	
	# Max acceleration of the character
	export(float) var maxAcceleration = 100
	
	# Time over which to achieve target speed
	var timeToTarget = 0.1
	
	func _init(ch,tg):
		self.character = ch
		self.target = tg
	
	func getSteering(target):
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Acceleration tries to get to the target velocity
		steer.linear = target.steering.velocity - character.steering.velocity
		steer.linear /= timeToTarget

		# Check if the acceleration is too fast
		if (steer.linear.length() > maxAcceleration):
			steer.linear = steer.linear.normalized()
			steer.linear *= maxAcceleration
			
		# Output the steering
		steer.velocity = character.steering.velocity
		steer.angular = 0
		
		return steer