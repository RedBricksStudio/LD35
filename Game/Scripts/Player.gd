extends KinematicBody2D

var speed = 250
var direction = Vector2(0, 0)
var shapes = ['robot', 'alien']
var alien_texture
var robot_texture
var current_shape = shapes[0]

func _fixed_process(delta):
    
	if Input.is_action_pressed('move_up'):
		direction = Vector2(0, -1)
	elif Input.is_action_pressed('move_down'):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed('move_left'):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed('move_right'):
		direction = Vector2(1, 0)
	else:
		direction = Vector2(0, 0)

	move(direction * speed * delta)

func _ready():
    set_fixed_process(true)

    robot_texture = preload("res://Textures/icon.tex")
	alien_texture = preload("res://Textures/AlienThingy.tex")

func get_shape():
	return current_shape

func next_shape():
	if current_shape == shapes[0]:
		set_texture(alien_texture)
		current_shape = shapes[3]
	else:
		set_texture(robot_texture)
		current_shape = shapes[0]
