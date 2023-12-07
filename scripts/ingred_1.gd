class_name food extends Area2D

signal collision
var inside = false
	
@export var speed = 100

func _physics_process(delta):
	global_position.y += speed * delta
	print(inside)


func _on_body_entered(body):
	if body is starter:
		print("entered body")
		inside = true
		collision.emit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("exited")
	queue_free()


func _on_body_exited(body):
	inside = false
