extends Node2D

@export var burger_attack: Array[PackedScene] = []

@onready var sounds = [$OMG, $YEAH]

var health = 100
var can_fire = true

func _ready():
	$HealthBar.value = health

func _on_button_pressed():
	fire()
	can_fire = false

func _on_travis_hitbox_area_entered(area):
	area.queue_free()
	$Travis.play("celebrate")
	sounds.pick_random().play()
	await get_tree().create_timer(0.75).timeout
	$Travis.play("idle")
	can_fire = true
	health -= 20
	$HealthBar.value = health

func fire():
	if can_fire:
		var burger = burger_attack[0].instantiate()
		burger.global_position.x = -150
		burger.global_position.y = 337
		$BurgerNode.add_child(burger)
	
func _process(delta):
	if health <= 0:
		get_tree().change_scene_to_file("res://MainScenes/win_screen.tscn")
