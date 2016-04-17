extends Node2D

var speed = 250
var direction = Vector2(0, 0)
var attacking = false
var talk_threshold = 100
var changing = false

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_node("player").get_pos()
	if attacking or changing:
		pass
	elif Input.is_action_pressed("attack"):
		direction = Vector2(0, 0)
		attacking = true
		get_node("AnimationPlayer").play("PlayerAttack")
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
	
	if Input.is_action_pressed("next_shape") and not changing:
		changing = true
		get_node("AnimationPlayer").play("ShapeShift")
	elif Input.action_press("prev_shape") and not changing:
		changing = true
		get_node("AnimationPlayer").play("ShapeShift")
	
	pos += direction * speed * delta
	get_node("player").set_pos(pos)
	
	if Input.is_action_pressed("talk"):
		talk_to_enemies()
	

func _attack_finished():
	attacking = false

func talk_to_enemies():
	var talkable_npcs = get_tree().get_nodes_in_group("talkable")
	var player = get_node("player")
	var closest_distance = 9999
	var closest
	for npc in talkable_npcs:
		if player.get_pos().distance_to(npc.get_pos()) < closest_distance:
			closest_distance = player.get_pos().distance_to(npc.get_pos())
			closest = npc
	
	if closest_distance < talk_threshold:
		closest._being_talked(player.get_shape())

func dialog_change(string):
	get_node("Dialog").set_text(string)

func _done_changing():
	changing = false
