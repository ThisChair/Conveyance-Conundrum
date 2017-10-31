extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	pass

func _on_LandPad_body_exit( body ):
	print("aaaaaaaaaaa")
	if body.is_in_group("jumper"):
		body.set_collision_mask_bit(1, true)
		body.set_layer_mask_bit (1, true)

func _on_LandPad_body_enter( body ):
	print("nu")
