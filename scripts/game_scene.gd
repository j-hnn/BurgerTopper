extends Node2D

@export var food_scenes: Array[PackedScene] = []

@onready var ingred_0 = $ingred_0
@onready var ingred_1 = $ingred_1
@onready var time_text = $CanvasLayer/TimeText
@onready var timer = $Timer
@onready var food_container = $food_container
@onready var spawn_location = $spawn_location

var done_burgers = 0

func _ready():
	pass

func _process(delta):
	pass


func _on_button_pressed():
	print("pressed")

func _inside_or_not():
	pass
