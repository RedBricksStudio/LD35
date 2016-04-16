extends Node2D

var speed = 250
var direction = Vector2(0, 0)
var attacking = false

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_node('player').get_pos()
	if attacking:
		pass
	elif Input.is_action_pressed('attack'):
		direction = Vector2(0, 0)
		attacking = true
		get_node('AnimationPlayer').play('PlayerAttack')
	elif Input.is_action_pressed('move_up'):
		direction = Vector2(0, -1)
	elif Input.is_action_pressed('move_down'):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed('move_left'):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed('move_right'):
		direction = Vector2(1, 0)
	else:
		direction = Vector2(0, 0)
	
	pos += direction * speed * delta
	
	get_node('player').set_pos(pos)

func _attack_finished():
	attacking = false
