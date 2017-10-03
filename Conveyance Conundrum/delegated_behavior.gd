extends "behavior.gd"

class Pursue:
	
	# Maximum allowed prediction time
	export(float) var maxPrediction = 6.5
	
	# Instantiation of delegated seek class
	var seek
	
	func _init(s):
		self.seek = s 
	
	func getSteering():
		
		# 1. Calculate the target to delegate to seek
		# Work out distance to target
		var direction = seek.target.get_pos() - seek.character.get_pos()
		var distance = direction.length()
		
		# Work out our current speed
		var speed = seek.character.steering.velocity.length()
		
		var prediction
		# Check if the speed is too small to give a reasonable prediction time
		if (speed <= distance / maxPrediction):
			prediction = maxPrediction
		# Otherwise calculate the prediction time
		else:
			prediction = distance / speed
			
		# Put the target together
		var explicitTarget = DummyObject.new(seek.target.position,seek.target.steering.velocity)
		seek.target = explicitTarget
		seek.target.position += seek.target.steering.velocity * prediction
		
		# 2. Delegate to seek
		return seek.getSteering()
		
class DummyObject:
	
	var position
	var steering = SteeringBehavior.new()
	
	func _init(pos,vel):
		self.position = pos
		self.steering.velocity = vel