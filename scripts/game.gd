extends Node2D

@export var food_scenes: Array[PackedScene] = []

@onready var food_spawn_location = $FoodSpawnLocation
@onready var food_container = $FoodContainer
@onready var stack_position = $stack_position
@onready var countdown_timer = $CountdownTimer
@onready var time_left = $timeLeft
@onready var progress_bar = $ProgressBar
@onready var time_progress_bar = $TimeProgressBar
@onready var travis = $travis

var food_number = 0
var total_burgers = 0
var speed_multiplier = 1
var inornot = false

var start_time = 300
var sec = start_time

func game_time():
	if sec > 0:
		sec -= 1
		time_left.text = str(sec)
		time_progress_bar.value -= 1

func _ready():
	time_progress_bar.value = start_time
	countdown_timer.start()
	spawn_food()

func _on_button_pressed():
	if inornot == true:
		update_food()
		spawn_food()
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
	elif torf == false:
		inornot = false
		print("gameover")

func update_food():
	progress_bar.value += 2.5
	if total_burgers < 5:
		if food_number < len(food_scenes) - 1:
			food_number += 1
		else:
			food_number = 0
			total_burgers += 1
			speed_multiplier += 0.75
			travis.play("celebrate")
	elif total_burgers == 5:
		get_tree().change_scene_to_file("res://win_screen.tscn")

func _on_countdown_timer_timeout():
	game_time()
