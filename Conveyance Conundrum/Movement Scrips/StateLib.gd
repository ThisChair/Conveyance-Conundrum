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
		character.get_node("SamplePlayer2D").play("alarm")

class TargetHidden:
	extends "Transition.gd"
	
	var target
	var radius
	var character
	
	func _init(ch, tg):
		self.character = ch
		self.target = tg
	
	func isTriggered():
		var space_state = character.get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(
			character.get_pos(),
			target.get_pos(),
			[character, target]
		)
		return not result.empty()

	func getAction():
		var sprite = character.get_node("Sprite")
		sprite.set_texture(load("res://bomba.png"))
		character.get_node("SamplePlayer2D").stop_all()
		character.steering = SteeringBehavior.new()

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
		if distance <= radius:
			var space_state = character.get_world_2d().get_direct_space_state()
			var result = space_state.intersect_ray(
				character.get_pos(),
				target.get_pos(),
				[character, target]
			)
			return result.empty()
		return false
		
	func getAction():
		var sprite = character.get_node("Sprite")
		sprite.set_texture(load("res://bomba_ANGERY.png"))