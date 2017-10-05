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
		#var explicitTarget = DummyObject.new(target.position)
		var explicitTarget = Node2D.new()
		explicitTarget.set_pos(
			target.get_pos() + target.steering.velocity * prediction
		)
		
		seek = Seek.new(character,explicitTarget)
		#seek.target.position += seek.target.steering.velocity * prediction
		
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
		explicitTarget.set_rot(atan2(-direction.x,-direction.y))
		
		
		align = Align.new(character,explicitTarget)
		var ste = align.getSteering()
		
		return align.getSteering()
	

