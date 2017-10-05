extends "behavior.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Instantiation of new seek class
	var seek = RadiusSeek.new(get_parent(),get_node("/root/level/player"))
	
	# Calculate the new steering and give it to the parent
	var steering = seek.getSteering()
	get_parent().steering = steering
	
	# Change the character sprite
	var sprite = get_node("/root/level/seeking box/Sprite")
	
	if (steering.velocity != Vector2(0,0)):
		sprite.set_texture(load("res://bomba_ANGERY.png"))
	else:
		sprite.set_texture(load("res://bomba.png"))	
	
	
