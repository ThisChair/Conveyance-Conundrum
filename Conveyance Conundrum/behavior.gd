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
	var radius = 100
	
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