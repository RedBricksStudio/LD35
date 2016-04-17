extends KinematicBody2D

var speed = 250
var direction = Vector2(0, 0)


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


