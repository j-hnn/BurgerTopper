extends Node2D

@export var food_scene: Array[PackedScene] = []
@export var completed_Scene: Array[PackedScene] = []

@onready var food_container = $FoodContainer
@onready var stack_container = $StackContainer
@onready var completed_container = $CompletedContainer
@onready var food_off_marker = $FoodOffMarker
@onready var completed_burger_marker = $CompletedBurgerMarker
@onready var completetion_bar = $CanvasLayer/Header/CompletionBar
@onready var time_left_bar = $CanvasLayer/Header/TimeLeftBar
@onready var time_left_text = $CanvasLayer/Header/TimeLeftText
@onready var timer = $Timer
@onready var travis = $Travis
@onready var bun_hit_box = $BunBottom/BunCollisionBox

var pressed = false
var inside = false
var food_number = 0
var speed_multiplier = 0.75
var complete_burger_x = 0
var total_stacks = 0
var start_time = 200
var sec = start_time
var stack_positions = [460, 432, 412, 399, 354, 319, 317, 304, 255]

func _ready():
	time_left_bar.value = 300
	time_left_bar.value = start_time
	spawn_food()

func spawn_food():
	pressed = false
	inside = false
	await get_tree().create_timer(randf_range(0, 2)).timeout
	var food = food_scene[food_number].instantiate()
	food.global_position.x = 247
	food.inside.connect(_on_food_inside)
	food_container.add_child(food)
	
func _on_food_inside():
	inside = true

func _on_button_pressed():
	pressed = true
	
func _process(delta):
	
	var food_node = food_container.get_node("food" + str(food_number))
	if pressed and inside:
		if food_node != null:
			food_node.queue_free()
			completetion_bar.value += 2.5
			stack_food()
			update_food()
			spawn_food()
	elif pressed and not inside:
		get_tree().change_scene_to_file("res://lose_screen.tscn")
		
	if food_node != null:
		if food_node.global_position.y >= food_off_marker.global_position.y:
			get_tree().change_scene_to_file("res://lose_screen.tscn")
		
func stack_food():
	var food = food_scene[food_number].instantiate()
	food.speed = 0
	food.global_position.x = 247
	food.global_position.y = stack_positions[food_number]
	stack_container.add_child(food)
	
	
func update_food():
	if total_stacks < 5:
		if food_number < len(food_scene) - 1:
			food_number += 1
		elif food_number == len(food_scene) - 1:
			food_number = 0
			total_stacks += 1
			travis.play("celebrate")
			add_complete_burger()
			restart_stack()
			await get_tree().create_timer(2.7).timeout
			travis.play("idle")
	
func restart_stack():
	await get_tree().create_timer(0.5).timeout
	for child in stack_container.get_children():
		child.queue_free()

func _on_timer_timeout():
	game_time()
	
func game_time():
	if sec > 0:
		sec -= 1
		time_left_text.text = str(sec)
		time_left_bar.value -= 1
	if total_stacks == 5:
		get_tree().change_scene_to_file("res://win_screen.tscn")

func add_complete_burger():
	var burger = completed_Scene[0].instantiate()
	burger.global_position = Vector2(complete_burger_x, 564)
	completed_container.add_child(burger)
	complete_burger_x += 100
