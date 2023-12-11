extends Node2D

signal pressed

@export var food_scenes: Array[PackedScene] = []

@onready var food_spawn_location = $FoodSpawnLocation
@onready var food_container = $FoodContainer
@onready var stack_position = $stack_position

var food_number = 0
var total_burgers = 0
var speed_multiplier = 1
var inornot = false

func _ready():
	spawn_food()

func _on_button_pressed():
	if inornot == true:
		update_food()
		pressed.emit()
		print("win")
	else:
		get_tree().reload_current_scene()

func _on_spawn_button_pressed():
	spawn_food()

func spawn_food():
	var food = food_scenes[food_number].instantiate()
	food.speed = food.speed * speed_multiplier
	food.global_position = food_spawn_location.global_position
	food.inside.connect(_inside_bun)
	food_container.add_child(food)
	
func _inside_bun(torf):
	if torf == true:
		inornot = true
		print("inside")
	elif torf == false:
		inornot = false
		print("gameover")

func update_food():
	if food_number < len(food_scenes) - 1:
		food_number += 1
	else:
		food_number = 0

func _button_pressed():
	pass
