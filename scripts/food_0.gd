class_name food extends Area2D

signal inside

@export var speed = 200

func _process(delta):
	global_position.y += speed * delta

func _on_area_entered(area):
	if area is BunBottom:
		inside.emit()
