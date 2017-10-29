extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_JumpPad_body_enter( body ):
	print(str('Body entered: ', body.get_name()))
