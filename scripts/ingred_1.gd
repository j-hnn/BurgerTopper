class_name food extends Area2D

@export var speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y += speed * delta


func _on_body_entered(body):
	if body is starter:
		body.die()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("exited")
