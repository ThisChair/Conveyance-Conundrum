extends KinematicBody2D

# Member variables
const WALK_SPEED = 5
const MAX_SPEED = 200
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

	var motion = velocity * delta
	move(motion)
	
	# Slide on terrain collisions
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
