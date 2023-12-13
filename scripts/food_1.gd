extends Area2D

signal inside

@export var speed = 100

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	queue_free()

func _on_area_entered(area):
	if area is base:
		die()
		inside.emit(true)

func _on_area_exited(area):
	if area is base:
		die()
		#get_tree().change_scene_to_file("res://lose_screen.tscn")
