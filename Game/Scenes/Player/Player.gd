extends KinematicBody2D

var speed = 250
var direction = Vector2(0, 0)
var shapes = ["robot"]
var current_shape = shapes[0]
var attacking = false
var talking = false
var shapeshifting = false
export var talk_threshold = 5000
export var attack_threshold = 5000
onready var sprite = get_node("Sprite")
onready var robot_texture = sprite.get_texture()
onready var texture_dict = {"robot": robot_texture}

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if attacking or shapeshifting:
		pass
	elif Input.is_action_pressed("talk"):
		talking = true
		talk()
	elif Input.is_action_pressed("attack"):
		attacking = true
		direction = Vector2(0, 0)
		get_node("PlayerAnimations").play("Attack")
		attack()
#	elif Input.is_action_pressed("prev_shape"):
#		shapeshifting = true
#		direction = Vector2(0, 0)
#		get_node("PlayerAnimations").play("PrevShape")
	elif Input.is_action_pressed("next_shape") and shapes.size() > 1:
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
	set_z(get_pos().y)
	if not get_node("PlayerAnimations").is_playing():
		get_node("PlayerAnimations").play("Idle")

func next_shape():
	current_shape = shapes[(shapes.find(current_shape) + 1 ) % shapes.size()]
	get_node("Sprite").set_texture(texture_dict[current_shape])
	if (current_shape == "boss"):
		get_node("../VIPwin").set_shape_as_trigger(0, true)
	else:
		get_node("../VIPwin").set_shape_as_trigger(0, false)

func talk():
	var talkable_npcs = get_tree().get_nodes_in_group("talkable")
	if talkable_npcs.empty():
		talking = false
		return
		
	var closest_distance = get_pos().distance_squared_to(talkable_npcs[0].get_pos())
	var closest = talkable_npcs[0]
	for npc in talkable_npcs:
		if get_pos().distance_squared_to(npc.get_pos()) < closest_distance:
			closest_distance = get_pos().distance_squared_to(npc.get_pos())
			closest = npc
	
	if closest_distance < talk_threshold:
		closest._being_talked(current_shape)
		talking = false
	else:
		talking = false

func attack():
	var attackable_npcs = get_tree().get_nodes_in_group("npcs")
	if attackable_npcs.empty():
		return
		
	var closest_distance = get_pos().distance_squared_to(attackable_npcs[0].get_pos())
	var closest = attackable_npcs[0]
	for npc in attackable_npcs:
		if get_pos().distance_to(npc.get_pos()) < closest_distance:
			closest_distance = get_pos().distance_to(npc.get_pos())
			closest = npc
			
	if closest_distance < attack_threshold:
		var npc_shape = closest._being_attacked()
		print (npc_shape)
		if shapes.find(npc_shape) == -1:
			texture_dict[npc_shape] = closest.get_texture()
			shapes.append(npc_shape)

func _attack_finished():
	attacking = false

func _shapeshifting_finished():
	shapeshifting = false