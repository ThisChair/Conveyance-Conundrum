extends "kinematic.gd"

export(float) var max_spd = 100
var steer = SteeringBehavior.new()
var rot = 0
func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if (Input.is_action_pressed("ui_up")):
		steer.linear.y += -1
	if (Input.is_action_pressed("ui_down")):
		steer.linear.y += 1
	if (Input.is_action_pressed("ui_left")):
		steer.linear.x += -1
	if (Input.is_action_pressed("ui_right")):
		steer.linear.x += 1
	if (Input.action_release("ui_up")):
		steer.linear.y = 0
	if (Input.action_release("ui_down")):
		steer.linear.y = 0
	if (Input.action_release("ui_left")):
		steer.linear.x = 0
	if (Input.action_release("ui_right")):
		steer.linear.x = 0
	steer.linear = steer.linear.normalized()
	if steer.linear.length() > 0:
		 rot = atan2(-steer.linear.x, steer.linear.y)
	self.get_parent().steering.linear = steer.linear * max_spd
	self.get_parent().orientation = rot
