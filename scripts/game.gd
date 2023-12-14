extends Node2D

@export var food_scenes: Array[PackedScene] = []
@export var complete_burger_scenes: Array[PackedScene] = []

@onready var food_spawn_location = $FoodSpawnLocation
@onready var food_container = $FoodContainer
@onready var stack_position = $stack_position
@onready var countdown_timer = $CountdownTimer
@onready var time_left = $timeLeft
@onready var progress_bar = $ProgressBar
@onready var time_progress_bar = $TimeProgressBar
@onready var travis = $travis
@onready var completed_burger_container = $CompletedBurgerContainer
@onready var button_sound = $ButtonSound
@onready var burger_complete_sound = $BurgerCompleteSound

var food_number = 0
var total_burgers = 0
var speed_multiplier = 1
var inornot = false
var complete_burger_x = 0
var start_time = 300
var sec = start_time

func game_time():
	if sec > 0:
		sec -= 1
		time_left.text = str(sec)
		time_progress_bar.value -= 1
		if total_burgers == 5:
			get_tree().change_scene_to_file("res://win_screen.tscn")

func _ready():
	time_progress_bar.value = start_time
	countdown_timer.start()
	spawn_food()
	travis.play("idle")

func _on_button_pressed():
	button_sound.play()
	if inornot == true:
		update_food()
		spawn_food()
	else:
		get_tree().change_scene_to_file("res://lose_screen.tscn")

func spawn_food():
	await get_tree().create_timer(randf_range(0, 2)).timeout
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
		get_tree().change_scene_to_file("res://lose_screen.tscn")

func update_food():
	progress_bar.value += 2.5
	if total_burgers < 5:
		if food_number < len(food_scenes) - 1:
			food_number += 1
		else:
			food_number = 0
			total_burgers += 1
			speed_multiplier += 0.75
			add_complete_burger()
			burger_complete_sound.play()
			travis.play("celebrate")
			await get_tree().create_timer(1.0).timeout
			travis.play("idle")

func _on_countdown_timer_timeout():
	game_time()

func add_complete_burger():
	var burger = complete_burger_scenes[0].instantiate()
	burger.global_position = Vector2(complete_burger_x, 560)
	completed_burger_container.add_child(burger)
	complete_burger_x += 100
