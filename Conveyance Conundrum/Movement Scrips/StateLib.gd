extends "StateMachine.gd"

class IdleState:
	extends "State.gd"
	var timer = 0
	
	func getAction():
		if timer == 0:
			timer = 100
			print("Boring...")
		if timer > 0:
			timer -= 1
	
	func getEntryAction():
		print("Nothing to do.")
		
	func getExitAction():
		print("Well, time to work!")

class PursueState:
	extends "State.gd"
	const Behavior = preload("res://Movement Scrips/delegated_behavior.gd")
	var target
	var character
	
	func _init(ch, tg):
		self.character = ch
		self.target = tg
	
	func getAction():
		var pursue = Behavior.Pursue.new(character,target)
		character.steering = pursue.getSteering()
	
	func getEntryAction():
		print("RUN.")
		
	func getExitAction():
		print("Well...")

class TargetClose:
	extends "Transition.gd"
	
	var target
	var radius
	var character
	
	func _init(ch, tg, r):
		self.character = ch
		self.target = tg
		self.radius = r
	
	func isTriggered():
		var distance = (character.get_pos() - target.get_pos()).length()
		print(distance)
		return distance <= radius
		
	func getAction():
		var sprite = character.get_node("Sprite")
		sprite.set_texture(load("res://bomba_ANGERY.png"))