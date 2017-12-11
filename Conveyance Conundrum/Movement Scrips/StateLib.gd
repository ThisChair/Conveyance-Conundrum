extends "StateMachine.gd"

class IdleState:
	extends "State.gd"
	var timer = 0
	
	func getAction():
		if timer == 0:
			timer = 100
			pass
		if timer > 0:
			timer -= 1
	
	func getEntryAction():
		pass
		
	func getExitAction():
		pass

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
		character.get_node("Light2D").show()

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
		character.get_node("Light2D").hide()
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
		var light = character.get_node("Light2D")
		light.show()
		sprite.set_texture(load("res://bomba_ANGERY.png"))

class BlockEnemy:
	extends "State.gd"
	const Behavior = preload("res://Movement Scrips/behavior.gd")
	var character
	var player
	var enemy
	
	func _init(ch, pl, e):
		character = ch
		player = pl
		enemy = e
		
	func getAction():
		pass
		

class PathfollowCall:
	extends "Transition.gd"
	var machine
	
	func _init(m):
		machine = m
	
	func isTriggered():
		return machine.called
	
	func getAction():
		machine.called = false

class ExploreCall:
	extends "Transition.gd"
	var machine
	
	func _init(m):
		machine = m
	
	func isTriggered():
		return machine.explore
	
	func getAction():
		machine.explore = false

class FollowCall:
	extends "Transition.gd"
	var machine
	
	func _init(m):
		machine = m
	
	func isTriggered():
		return machine.follow
	
	func getAction():
		machine.follow = false

class NotMoving:
	extends "Transition.gd"
	var character
	
	func _init(ch):
		character = ch
		
	func isTriggered():
		return character.steering.velocity == Vector2(0,0)
	func getAction():
		pass

class Follow:
	extends "State.gd"
	const Behavior = preload("res://Movement Scrips/behavior.gd")
	var caller
	var character
	
	func _init(ch, ca):
		character = ch
		caller = ca
	
	func getAction():
		print("Estado perseguir")
		var arrive = Behavior.Arrive.new(character, caller)
		character.steering = arrive.getSteering()

class Explore:
	extends "State.gd"
	const Behavior = preload("res://Movement Scrips/behavior.gd")
	var caller
	var character
	
	func _init(ch, ca):
		character = ch
		caller = ca
	
	func getAction():
		print("Estado explorar")
		var flee = Behavior.Flee.new(character, caller)
		character.steering = flee.getSteering()

class Called:
	extends "State.gd"
	const Behavior = preload("res://Movement Scrips/delegated_behavior.gd")
	var caller
	var character
	var graph_node
	
	var path = []
	
	func _init(ch, ca):
		character = ch
		caller = ca
	
	func getEntryAction():
		graph_node = character.get_parent().get_node("/root/Demo/level graph/")
		var initial = graph_node.findTriangle(character.get_global_pos())
		var final = graph_node.findTriangle(caller.get_global_pos())
		path = graph_node.optimalPath(initial,final)
		
	func getAction():
		# Instantiation of new path following class
		var path_follow = Behavior.FollowPath.new(character,path,null)
		# Calculate the new blended steering and give it to the parent
		character.steering = path_follow.getSteering()