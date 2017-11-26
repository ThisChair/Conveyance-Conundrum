extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(Vector2) var direction = Vector2(1,0)
export(float) var minSpeed = 45.0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_JumpPad_body_enter( body ):
	if body.is_in_group("jumper"):
		var projection = body.steering.velocity.dot(direction)
		if projection >= minSpeed:
			body.set_collision_mask_bit(1, false)
			body.set_layer_mask_bit (1, false)
			
			body.flight.velocity = 3
			body.flight.acceleration = 1
