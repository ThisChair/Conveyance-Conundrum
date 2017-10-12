extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var CD = 400
var bullet_scene = load("res://bullet.tscn")
var count = CD
func _ready():
	set_fixed_process(false)

func _fixed_process(delta):
	if count == CD:
		var rotation  = get_parent().get_rot()
		var direction = Vector2(sin(rotation), cos(rotation))
		
		var distance_from_me = 50
		var spawn_point = get_parent().get_global_pos() + direction * distance_from_me
		
		var bullet = bullet_scene.instance()
		var world  = self.get_parent().get_parent()
		
		bullet.set_global_pos(spawn_point)
		
		world.add_child(bullet)
		
		bullet.set_global_pos(spawn_point)
		bullet.set_global_pos(spawn_point)
		bullet.steering.linear = direction * 10
		bullet.flight.acceleration = 10
	count -= 1
	if count == 0:
		count = CD