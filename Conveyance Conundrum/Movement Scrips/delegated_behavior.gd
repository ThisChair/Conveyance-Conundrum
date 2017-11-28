extends "behavior.gd"

class Pursue:
	
	# Maximum allowed prediction time
	export(float) var maxPrediction = 6.5
	
	var character
	var target
	
	# Instantiation of delegated seek class
	var seek
	
	# Initialization parameters for the class
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	func getSteering():
		
		# 1. Calculate the target to delegate to seek
		# Work out distance to target
		var direction = target.get_pos() - character.get_pos()
		var distance = direction.length()
		
		# Work out our current speed
		var speed = character.steering.velocity.length()
		
		var prediction
		# Check if the speed is too small to give a reasonable prediction time
		if (speed <= distance / maxPrediction):
			prediction = maxPrediction
		# Otherwise calculate the prediction time
		else:
			prediction = distance / speed
		
		# Put the target together
		var explicitTarget = Node2D.new()
		explicitTarget.set_pos(target.get_pos() + target.steering.velocity * prediction)
		
		seek = Seek.new(character,explicitTarget)
		
		# 2. Delegate to seek
		return seek.getSteering()
		
class Face:
	
	var character
	var target
	
	# Instantiation of delegated seek class
	var align
	
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
		
	func getSteering():
		
		var direction = target.get_pos() - character.get_pos()
		
		if direction.length() == 0:
			return character.steer
			
		var explicitTarget = Node2D.new()
		explicitTarget.set_pos(character.get_pos())
		explicitTarget.set_rot(atan2(direction.x,direction.y))
		
		align = Align.new(character,explicitTarget)
		
		return align.getSteering()
	
class LookWhereYoureGoing:
	
	var character
	
	# Instantiation of delegated align class
	var align
	
	# Initialization parameters for the class
	func _init(ch):
		self.character = ch 
		
	func getSteering():
		
		if character.steering.velocity.length() == 0:
			return character.steering
			
		var explicitTarget = Node2D.new()
		explicitTarget.set_rot(atan2(-character.steering.velocity.x, character.steering.velocity.y))
		explicitTarget.set_pos(character.get_pos())
		
		align = Align.new(character, explicitTarget)
		
		return align.getSteering()
		
class ObstacleAvoidance:
	
	# Minimum distance to a wall
	var avoid_distance = 150
	
	# Distance to look ahead for a collision
	var lookahead = 50
	
	# Character and target data
	var character
	var target = Node2D.new()
	
	# Raycast
	var raycast_query
	
	# Direction to which cast the raycast
	var cast_direction
	
	# Collision data
	var collision_normal
	var collision_position
	
	var steer = SteeringBehavior.new()
	var seek
	
	# Initialization parameters for the class
	func _init(ch,ray):
		self.character = ch
		self.raycast_query = ray
		self.steer.velocity = Vector2(0,0)
		self.steer.rotation = 0
		self.steer.linear = Vector2(0,0)
		self.steer.angular = 0
		
	func getSteering():
		
		# 1. Calculate the target to delegate to seek
		cast_direction = Vector2(sin(character.get_rot()),cos(character.get_rot()))
		cast_direction = cast_direction.normalized()
		cast_direction *= 50

		raycast_query.set_cast_to(cast_direction)

		# Check for collisions
		if (raycast_query.is_colliding()):
			collision_normal = raycast_query.get_collision_normal()
			collision_position = raycast_query.get_collision_point()
		# if no collision, do nothing
		else:
			return steer
			
		# Otherwise create a target
		target.set_global_pos(collision_position + collision_normal * avoid_distance)
		
		# 2. Delegate to seek
		seek = Seek.new(character,target)
		
		return seek.getSteering()

class FollowPath:
	
	# Character and target data
	var character
	var target = Node2D.new()
	
	# Path to follow
	var path
	var distance
	
	# Whenever or not our path is a patrol route (looped)
	# default value is false
	var looped = false
	var current_node
	
	# Instantiation of delegated seek class
	var seek
	
	# Admission radius for arriving at a node
	var radius = 50
	
	# Iterator
	var i = 0
	
	# Initialization parameters for the class
	# ch : character data
	# p : an array of Vector2() describing a path
	# l : a boolean indicating if our path has a loop
	func _init(ch,p,l):
		self.path = p
		self.character = ch
		if l == null:
			pass
		else:
			self.looped = l

	func getSteering():
		
		# 1. Calculate the target to delegate to face
		
		# We've reached the end of our path, stop
		if path.empty():
			var steer = SteeringBehavior.new()
			steer.nullify()
			return steer
		
		# Calculate the distance to our current path
		target.set_pos(path[0])
		distance = target.get_pos() - character.get_pos()
		
		# If we're within the acceptance radius, then we've reached
		# our current target, seek the next one
		if distance.length() <= radius:
			# If we don't have a patrol route, then just 
			# remove the current node from the list
			if !looped:
				path.pop_front()
			# Otherwise remove the current node and
			# then add it at the end of the list to create a loop
			else:
				current_node = path[0]
				path.pop_front()
				path.append(current_node)
		
		# 2. Delegate to seek
		seek = Seek.new(character,target)
		
		return seek.getSteering()