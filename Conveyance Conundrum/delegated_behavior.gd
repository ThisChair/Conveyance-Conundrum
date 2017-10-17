extends "behavior.gd"

class Pursue:
	
	# Maximum allowed prediction time
	export(float) var maxPrediction = 6.5
	
	var character
	var target
	
	# Instantiation of delegated seek class
	var seek
	
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
		var ste = align.getSteering()
		
		return align.getSteering()
	
class LookWhereYoureGoing:
	
	var character
	
	# Instantiation of delegated seek class
	var align
	
	# Initialization parameters for the class
	func _init(ch):
		self.character = ch 
		
	func getSteering():
		
		if character.steering.velocity.length() == 0:
			return character.steering
			
		var explicitTarget = Node2D.new()
		explicitTarget.set_rot(atan2(-character.velocity.x, character.velocity.z))
		explicitTarget.set_pos(character.get_pos())
		
		align = Align.new(character, explicitTarget)
		
		return align.getSteering()
		
class ObstacleAvoidance:
	
	# Minimum distance to a wall
	var avoid_distance = 40
	
	# Distance to look ahead for a collision
	var lookahead = 50
	
	# Character data
	var character
	
	# Raycast
	var raycast_query
	
	# Collision data
	var collision_normal
	var collision_position
	
	var steer = SteeringBehavior.new()
	
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
		
		# Check for collisions
		if (!raycast_query.empty()):
			collision_normal = raycast_query.normal
			collision_position = raycast_query.position
		# if no collision, do nothing
		else:
			return steer
			
		# Otherwise create a target
		var target = Node2D.new()
		target.set_global_pos(collision_position + collision_normal * avoid_distance)
		
		# 2. Delegate to seek
		var seek = Seek.new(character,target)
		
		return seek.getSteering()