extends "res://scripts/start_screen.gd"

func _ready():
	$LoseSound.play()
	$CanvasLayer/AnimatedSprite2D.play("celebrate")
