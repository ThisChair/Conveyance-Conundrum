extends "kinematic.gd"

class BehaviorAndWeight:
	var behavior
	var weight
	
	func _init(b,w):
		self.behavior = b
		self.weight = w

class BlendedSteering:
	
	# List of BehaviorAndWeight instances
	var behaviors
	
	# Maximum acceleration and rotation
	var maxAcceleration = 100
	var maxRotation = 100
	
	# Initialization parameters for the class
	func _init(b_list):
		self.behaviors = b_list
	
	# Returns the acceleration required
	func getSteering():
		
		# New output steering for accumulation
		var steer = SteeringBehavior.new()
		var placeholder_steer
		
		# Accumulate all accelerations
		for behavior in behaviors:
			placeholder_steer = behavior.behavior.getSteering()
			steer.velocity += behavior.weight * placeholder_steer.velocity
			steer.rotation += behavior.weight * placeholder_steer.rotation
			steer.linear += behavior.weight * placeholder_steer.linear
			steer.angular += behavior.weight * placeholder_steer.angular
		
		# Crop the result and return
		if (steer.linear.length() > maxAcceleration):
			steer.linear = steer.linear.normalized()
			steer.linear *= maxAcceleration
		if (steer.angular > maxRotation):
			steer.angular = maxRotation
		
		return steer

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
		steer.rotation = character.steer.rotation
		steer.linear = character.steer.linear
		steer.angular = character.steer.angular
		
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
		steer.rotation = character.steer.rotation
		steer.linear = character.steer.linear
		steer.angular = character.steer.angular
		
		
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
		
	# Function that returns the new orientation to face
	func getNewOrientation(currentOrientation, velocity):
		if velocity.length() > 0:
			return velocity.angle()
		else:
			return currentOrientation
	
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
		steer.rotation = character.steering.rotation
		steer.angular = character.steering.angular
		
		# Face in the direction we want to move 
		character.set_rot(getNewOrientation(character.orientation,steer.velocity))
		
		return steer
		
class RadiusSeek:
	# Character and target data
	var character
	var target
	
	# Maximum allowed acceleration
	export(float) var maxAcceleration = 50
	
	# Seek radius
	export(float) var seekRadius = 100
	
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
		var distance = steer.linear.length()
		
		# Check if target is within seek radius
		if (distance > seekRadius):
			steer.nullify()
			return steer
		
		# Normalize and get to max speed
		steer.linear = steer.linear.normalized()
		steer.linear *= maxAcceleration
		
		steer.velocity = character.steering.velocity
		steer.rotation = character.steering.rotation
		steer.angular = character.steering.angular
		
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
		steer.rotation = character.steering.rotation
		steer.angular = character.steering.angular
		
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
		steer.rotation = character.steering.rotation
		steer.angular = character.steering.angular
		return steer

class Align:
	# Character and target dada
	var character
	var target
	
	export(float) var maxAngularAcceleration = 20
	export(float) var maxRotation = 10
	
	export(float) var targetRadius = 1
	
	
	export(float) var slowRadius = 90
	
	export(float) var timeToTarget = 0.1 
	
	# Intialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	func getSteering():
			# Output structure
		var steer = SteeringBehavior.new()
		
		var rotation = target.get_rotd() - character.get_rotd()
		
		rotation = fmod(rotation, (360))
		
		if abs(rotation) > 180:
			if (rotation < 0):
				rotation += 360
			if (rotation > 0):
				rotation -= 360
		
		var rotationSize = abs(rotation)
		
		if rotationSize <= targetRadius:
			return steer
		
		var targetRotation
		if rotationSize < slowRadius:
			targetRotation = maxRotation
		else:
			targetRotation = maxRotation * rotationSize / slowRadius
		
		targetRotation *= rotation / rotationSize
		
		steer.angular = targetRotation - character.get_rot()
		
		steer.angular /= timeToTarget
		
		var angularAcceleration = abs(steer.angular)
		if angularAcceleration > maxAngularAcceleration:
			steer.angular /= angularAcceleration
			steer.angular *= maxAngularAcceleration
			
		steer.linear = character.steering.linear
		steer.velocity = character.steering.velocity
		steer.rotation = character.steering.rotation
		steer.angular = deg2rad(steer.angular)
		
		return steer
		
class VelocityMatching:
	
	# Character and target data
	var character
	var target
	
	# Max acceleration of the character
	export(float) var maxAcceleration = 100
	
	# Time over which to achieve target speed
	var timeToTarget = 0.1
	
	# Initialization parameters for the class
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
		
class Separation:
	
	# Character and target data, target is a list of potential targets
	var character
	var targets
	
	# Threshold to take action
	var threshold = 200
	
	# Constant coefficient of decay for the inverse square law force
	var decay_coefficient = -400
	
	# Maximum acceleration for the character
	export (float) var maxAcceleration = 1000
	
	# Strength of repulsion
	var strength = 100
	
	# Initialization parameters for the class
	func _init(ch,tg):
		self.character = ch
		self.targets = tg
	
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Loop through each target
		for target in targets:
			
			# Check if the target is too close
			var direction = target.get_pos() - character.get_pos()
			var distance = direction.length()
			
			if distance < threshold:
				# Calculate the strength of repulsion
				strength = min(decay_coefficient / (distance * distance), maxAcceleration)
				
				# Add the acceleration
				direction = direction.normalized()
				steer.velocity = character.steering.velocity
				steer.linear += strength * direction
			
		# We've gone through all the targets, return the result

		return steer
		
class Flocking:
	
	# Character data
	var myself
	
	# List of agents in the flock
	var agentList
	
	# Maximum speed allowed
	var maxSpeed = 50
	
	# Point to seek
	var currentCenterOfMass
	
	# Initialization parameters for the class
	func _init(cm,me,ag_l):
		self.myself = me
		self.agentList = ag_l
		self.currentCenterOfMass = cm
	
	# Computes the aligment a character must face 
	# respective to the flock.
	# myself : our current character
	# AgentList : list of agents in the flock.
	func computeAligment(Myself,AgentList):
		
		# Computation vector
		var alignment = Vector2()
		
		# Number of neighbors
		var neighborCount = 0
		
		# Distance & direction to the agent
		var direction
		var distance
		
		# For each agent in the flock, we add it's velocity
		# to the computation vector, and the neighbor count is 
		# increased
		for agent in AgentList:

			if (agent != Myself):
				
				direction = agent.get_pos() - Myself.get_pos()
				distance = direction.length()
				# Get the distance and see if it's our agent 
				# is inside the flock
				if (distance < 200):
					# Save the agent velocity in the computation vector
					alignment += agent.steering.velocity
					neighborCount += 1
		
		# If we are alone in the flock,
		# return the null vector
		if (neighborCount == 0):
			return alignment
			
		alignment /= neighborCount
		alignment = alignment.normalized()
		return alignment
	
	# Computes the cohesion a character must apply to
	# remain in the flock.
	# proxyCenterOfMass : in case we wanna flock to a certain point.
	# myself : our current character
	# AgentList: list of agents in the flock
	func computeCohesion(proxyCenterOfMass,Myself,AgentList):
		
		# Flock's center of mass
		var centerOfMass = Vector2()
		
		# Direction to the center of mass
		var forceVector = Vector2()
		
		# Number of neighbors
		var neighborCount = 0
		
		# Distance & direction to the agent
		var direction
		var distance
		
		# For each agent in the flock, we add it's position
		# to the computation vector, and the neighbor count is 
		# increased
		for agent in AgentList:
			
			if (agent != Myself):
				
				direction = agent.get_pos() - Myself.get_pos()
				distance = direction.length()
				# Get the distance and see if our agent
				# is inside the flock
				if (distance < 200):
					# Save the agent position in the computation vector
					centerOfMass += agent.get_pos()
					neighborCount += 1
		
		# If we are alone in the flock,
		# return the null vector
		if (neighborCount == 0):
			return centerOfMass
		
		# If we're using a proxy center of mass to
		# flock to, then calculate the force vector
		# to it.
		if (proxyCenterOfMass != null):
			forceVector = proxyCenterOfMass - Myself.get_pos()
			forceVector = forceVector.normalized()
			return forceVector
		
		# Otherwise calculate the force vector pointing
		# to the flock's center of mass.
		centerOfMass /= neighborCount+1
		forceVector = centerOfMass - Myself.get_pos()
		forceVector = forceVector.normalized()
		return forceVector
		
	func computeSeparation(Myself,AgentList):
		
		# Computation vector
		var separation = Vector2()
		
		# Numbers of neighbors
		var neighborCount = 0
		
		# Distance & direction to the agent
		var direction
		var distance
		
		# For each agent in the flock, we add the distance from
		# the agent to the neighbor to the computation vector,
		# and the neighbor count is increased
		for agent in AgentList:
			
			if (agent != Myself):
				
				direction = agent.get_pos() - Myself.get_pos()
				distance = direction.length()
				# Get the distance and see if our agent
				# is inside the flock
				if (distance < 50):
					# Save the direction from our agent to the 
					# target agent in the computation vector
					separation += direction
					neighborCount += 1
		
		# If we are alone in the flock,
		# return the null vector
		if (neighborCount == 0):
			return separation
			
		separation /= neighborCount
		separation *= -1
		separation = separation.normalized()
		return separation
		
	func getSteering():
		
		# Calculate the 3 necessary behaviours
		var alignment = computeAligment(myself,agentList)
		var cohesion = computeCohesion(currentCenterOfMass,myself,agentList)
		var separation = computeSeparation(myself,agentList)
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Blend the behaviours into a single steering
		steer.velocity += alignment + cohesion + separation
		
		# Crop it to a maximum speed
		steer.velocity = steer.velocity.normalized()
		steer.velocity *= maxSpeed
		
		steer.linear = myself.steering.linear
		steer.rotation = myself.steering.rotation
		steer.angular = myself.steering.angular
		
		return steer 