extends KinematicBody2D

var speed = 250
var direction = Vector2(0, 0)
var shapes = ["robot", "alien"]
var alien_texture
var robot_texture
var current_shape = shapes[0]
var attacking = false
var talking = false
var shapeshifting = false
export var talk_threshold = 10000
export var attack_threshold = 100
var sprite

func _fixed_process(delta):
	if attacking or talking or shapeshifting:
		pass
	elif Input.is_action_pressed("talk"):
		talk()
	elif Input.is_action_pressed("attack"):
		attacking = true
		direction = Vector2(0, 0)
		get_node("PlayerAnimations").play("Attack")
#	elif Input.is_action_pressed("prev_shape"):
#		shapeshifting = true
#		direction = Vector2(0, 0)
#		get_node("PlayerAnimations").play("PrevShape")
	elif Input.is_action_pressed("next_shape"):
		shapeshifting = true
		direction = Vector2(0, 0)
		get_node("PlayerAnimations").play("NextShape")
	elif Input.is_action_pressed("move_up"):
		direction = Vector2(0, -1)
	elif Input.is_action_pressed("move_down"):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_left"):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_right"):
		direction = Vector2(1, 0)
	else:
		direction = Vector2(0, 0)
	
	move(direction * speed * delta)

func _ready():
	set_fixed_process(true)
	
	robot_texture = preload("res://Textures/icon.tex")
	alien_texture = preload("res://Textures/AlienThingy.tex")
	sprite = get_node("Sprite")

func get_shape():
	return current_shape

func next_shape():
	if current_shape == shapes[0]:
		sprite.set_texture(alien_texture)
		current_shape = shapes[1]
	else:
		sprite.set_texture(robot_texture)
		current_shape = shapes[0]

func talk():
	var talkable_npcs = get_tree().get_nodes_in_group("talkable")
	if talkable_npcs.empty():
		return
	var closest_distance = 9999
	var closest
	for npc in talkable_npcs:
		if get_pos().distance_squared_to(npc.get_pos()) < closest_distance:
			closest_distance = get_pos().distance_squared_to(npc.get_pos())
			closest = npc
	
	if closest_distance < talk_threshold:
		closest._being_talked(get_shape())

func attack():
	var attackable_npcs = get_tree().get_nodes_in_group("npcs")
	if attackable_npcs.empty():
		return
	var closest_distance = 9999
	var closest
	for npc in attackable_npcs:
		if get_pos().distance_squared_to(npc.get_pos()) < closest_distance:
			closest_distance = get_pos().distance_squared_to(npc.get_pos())
			closest = npc
	
	if closest_distance < attack_threshold:
		closest._being_attacked()

func _attack_finished():
	attacking = false

func _shapeshifting_finished():
	shapeshifting = false