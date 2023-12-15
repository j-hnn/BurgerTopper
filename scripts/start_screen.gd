extends Node2D

@onready var animated_sprite_2d = $CanvasLayer/AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("celebrate")
	$AudioStreamPlayer2D.play()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://MainScenes/game_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()
