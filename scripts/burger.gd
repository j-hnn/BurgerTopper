extends Area2D

@export var speed = 500

func _process(delta):
	global_position.x += speed * delta
