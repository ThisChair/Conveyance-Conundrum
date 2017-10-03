extends KinematicBody2D

# Constants
const WALK_SPEED = 1
var velocity = Vector2()

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
	if velocity.length() > 0:
		get_parent().set_rot(velocity.angle())
	get_parent().steering.velocity = velocity
#	get_parent().steering.rotation = atan2(-velocity.x,velocity.y)
	
