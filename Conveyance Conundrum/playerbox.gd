extends KinematicBody2D

# Constants
const WALK_SPEED = 1
var velocity = Vector2()
var state_jump = false
var state_fall = false
onready var original_scale = get_parent().get_scale()
onready var original_z = get_parent().get_z()


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Movement input
	if (Input.is_action_pressed("ui_up")):
		velocity.y += -WALK_SPEED
	if (Input.is_action_pressed("ui_down")):
		velocity.y += WALK_SPEED
	if (Input.is_action_pressed("ui_left")):
		velocity.x += -WALK_SPEED
	if (Input.is_action_pressed("ui_right")):
		velocity.x += WALK_SPEED

	if (Input.is_action_pressed("ui_select") and not state_fall):
		get_parent().set_z(original_z * 2)
		state_jump = true
	var actual_scale = get_parent().get_scale()
	if state_jump:
		get_parent().set_scale(actual_scale + original_scale/20)
		if actual_scale >= original_scale * 1.5:
			state_fall = true
			state_jump = false
			get_parent().set_scale(original_scale * 1.5)
	else:
		if (actual_scale > original_scale):
			get_parent().set_scale(actual_scale - original_scale/30)
		if (actual_scale < original_scale):
			get_parent().set_scale(original_scale)
			get_parent().set_z(original_z)
			state_fall = false

	
	velocity -= velocity / 100
	if velocity.length() > 0:
		get_parent().set_rot(velocity.angle())
	get_parent().steering.velocity = velocity
#	get_parent().steering.rotation = atan2(-velocity.x,velocity.y)
	
