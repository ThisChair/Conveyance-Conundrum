extends Node2D

class SteeringBehavior:
	var linear = Vector2(0,0)
	var angular= 0

var position = self.get_pos()
var orientation = self.get_rot()
var velocity = Vector2(0,0)
var rotation = 0.0
var steering = SteeringBehavior.new()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	position += velocity * delta
	orientation += rotation * delta
	velocity += steering.linear * delta
	rotation += steering.angular * delta
	self.set_pos(position)
	self.set_rot(orientation)
