extends KinematicBody2D

var waypoints
var currentWaypointPos
var currentWaypointIndex
var speed = 30
var direction = 0
export var robot_dialog = ""
export var guards_dialog = ""
export var attendee_dialog = ""
export var boss_dialog = ""
export var shape = ""

func _ready():
	add_to_group("npcs")
	add_to_group("talkable")
	waypoints = get_tree().get_nodes_in_group("Waypoints" + get_name())
	if not waypoints.empty():
		set_fixed_process(true)
		currentWaypointPos = waypoints[0].get_global_pos()
		currentWaypointIndex = 0
	else:
		set_process(true)

func _process(delta):
	if not get_node("NPCAnimation").is_playing():
		get_node("NPCAnimation").play("Idle")
	set_z(get_pos().y)

func _fixed_process(delta):
	var motion = Vector2()
	
	if not is_colliding():
		if not xReached():
			motion = xMove(delta)
		elif not yReached():
			motion = yMove(delta)
		else:
			nextWaypoint()
	
	move(motion)

func xReached():
	if abs(get_global_pos().x - currentWaypointPos.x) <= 2:
		return true
		
		
func yReached():
	if abs(get_global_pos().y - currentWaypointPos.y) <= 2:
		return true

func xMove(delta):
	var motion = Vector2()
	
	if get_pos().x <= currentWaypointPos.x:
		motion = speed * delta * Vector2(1, 0)
	else:
		motion = speed * delta * Vector2(-1, 0)
		
	return motion

func yMove(delta):
	var motion = Vector2()
	
	if get_global_pos().y <= currentWaypointPos.y:
		motion = speed * delta * Vector2(0, 1)
	else:
		motion = speed * delta * Vector2(0, -1)
		
	return motion

func nextWaypoint():
	if direction == 0:
		if currentWaypointIndex + 1 == waypoints.size():
			direction = 1
			currentWaypointIndex -= 1
		else:
			currentWaypointIndex += 1
	else:
		if currentWaypointIndex == 0:
			direction = 0
			currentWaypointIndex += 1
		else:
			currentWaypointIndex -= 1
	
	currentWaypointPos = waypoints[currentWaypointIndex].get_global_pos()

func _being_attacked():
	print("I'm being attacked")
	queue_free()
	return shape

func get_texture():
	return get_node("Sprite").get_texture()

func _being_talked(actor):
	if actor == "robot":
		get_node("../Dialog").dialog_change(robot_dialog)
	elif actor == "guard":
		get_node("../Dialog").dialog_change(guards_dialog)
	elif actor == "attendee":
		get_node("../Dialog").dialog_change(attendee_dialog)
	elif actor == "boss":
		get_node("../Dialog").dialog_change(boss_dialog)
