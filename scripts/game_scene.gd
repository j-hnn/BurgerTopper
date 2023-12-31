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
@onready var bun_collision_box = $BunBottom/BunCollisionBox
@onready var timer = $Timer
@onready var travis = $Travis
@onready var button_sounds = [$ButtonSound, $ButtonSound2, $ButtonSound3, $ButtonSound4, $ButtonSound5, $ButtonSound6]

var pressed = false
var inside = false
var food_number = 0
var speed_multiplier = 1
var complete_burger_x = 0
var total_stacks = 0
var start_time = 200
var sec = start_time
var stack_positions = [460, 432, 412, 399, 354, 319, 317, 304, 255]

func _ready():
	time_left_bar.value = start_time
	spawn_food()

# this function spawns the food
func spawn_food():
	pressed = false
	inside = false
	await get_tree().create_timer(randf_range(0, 2)).timeout
	var food = food_scene[food_number].instantiate()
	food.global_position.x = 247
	food.speed *= speed_multiplier
	food.inside.connect(_on_food_inside)
	food_container.add_child(food)
	
func _on_food_inside():
	inside = true

func _on_button_pressed():
	pressed = true
	button_sounds.pick_random().play()
	
func _process(delta):
	
	# this checks if the button has been pressed and if the food is inside the hitbox
	var food_node = food_container.get_node("food" + str(food_number))
	if pressed and inside:
		if food_node != null:
			food_node.queue_free()
			completetion_bar.value += 2.5
			stack_food()
			update_food()
			spawn_food()
	elif pressed and not inside:
		get_tree().change_scene_to_file("res://MainScenes/lose_screen.tscn")
		
	# this checks if the food is out of range
	if food_node != null:
		if food_node.global_position.y >= food_off_marker.global_position.y:
			get_tree().change_scene_to_file("res://MainScenes/lose_screen.tscn")
		
# this function stacks the food
func stack_food():
	var food = food_scene[food_number].instantiate()
	food.speed = 0
	food.global_position.x = 247
	food.global_position.y = stack_positions[food_number]
	bun_collision_box.global_position.y = stack_positions[food_number]
	stack_container.add_child(food)
	
# this function updates which food is spawned
func update_food():
	if total_stacks < 5:
		if food_number < len(food_scene) - 1:
			food_number += 1
		elif food_number == len(food_scene) - 1:
			food_number = 0
			total_stacks += 1
			travis.play("celebrate")
			$BurgerCompleteSound.play()
			add_complete_burger()
			restart_stack()
			speed_multiplier += 0.5
			await get_tree().create_timer(2.7).timeout
			travis.play("idle")
	
# this function restarts the stack
func restart_stack():
	await get_tree().create_timer(0.5).timeout
	bun_collision_box.global_position.y = 488
	for child in stack_container.get_children():
		child.queue_free()

func _on_timer_timeout():
	game_time()
	
# this controls the timer
func game_time():
	if sec > 0:
		sec -= 1
		time_left_text.text = str(sec)
		time_left_bar.value -= 1
	if total_stacks == 5:
		get_tree().change_scene_to_file("res://MainScenes/battle_scene.tscn")

# this function adds a burger once it has been fully stacked
func add_complete_burger():
	var burger = completed_Scene[0].instantiate()
	burger.global_position = Vector2(complete_burger_x, 564)
	completed_container.add_child(burger)
	complete_burger_x += 100
