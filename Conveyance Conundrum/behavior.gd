extends "kinematic.gd"


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

class KinematicSeek:
	var character
	var target
	export(float) var maxSpeed = 50
	
	func getNewOrientation(currentOrientation, velocity):
		if velocity.length() > 0:
			return atan2(-velocity.x, velocity.y)
		else:
			return currentOrientation
	
	func _init(ch, tg):
		self.target = tg
		self.character = ch 
	
	func getSteering():
		
		# Output structure
		var steer = SteeringBehavior.new()
		
		# Get direction to target
		steer.velocity = self.target.get_pos() - self.character.get_pos()
		
		# Normalize and get to max speed
		steer.velocity = steer.velocity.normalized()
		steer.velocity *= maxSpeed
		
		# Face movement direction
		
		character.set_rot(getNewOrientation(character.orientation, steer.velocity))
		
		steer.rotation = 0
		
		return steer