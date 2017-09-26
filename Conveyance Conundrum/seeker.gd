extends "behavior.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var seek = KinematicSeek.new(self.get_parent(), get_node("/root/level/chara"))
func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	self.get_parent().steering = self.seek.getSteering()