extends KinematicBody2D

var waypoints
var currentWaypointPos
var currentWaypointIndex
var speed = 200
var direction = 0


func _fixed_process(delta):
	
	var motion = Vector2()

	print(is_colliding())
	if (!is_colliding()):
		if (!xReached()):
			motion = xMove(delta)
		elif (!yReached()):
			motion = yMove(delta)
		else:
			nextWaypoint()
			
	move(motion)
	
func _ready():
	set_fixed_process(true)
	
	waypoints = get_tree().get_nodes_in_group("Waypoints")
	currentWaypointPos = waypoints[0].get_global_pos()
	currentWaypointIndex = 0
	
	
	
func xReached():
	
	if (abs(get_global_pos().x - currentWaypointPos.x) <= 2):
		return true
		
		
func yReached():
	
	if (abs(get_global_pos().y - currentWaypointPos.y) <= 2):
		return true
		
		
		
func xMove(delta):
	
	var motion = Vector2()
	
	if (get_pos().x <= currentWaypointPos.x):
		motion = speed * delta * Vector2(1, 0)
	else:
		motion = speed * delta * Vector2(-1, 0)
		
	return motion
	
	
func yMove(delta):
	
	var motion = Vector2()
	
	if (get_global_pos().y <= currentWaypointPos.y):
		motion = speed * delta * Vector2(0, 1)
	else:
		motion = speed * delta * Vector2(0, -1)
		
	return motion
		
		
		
	
func nextWaypoint():
	print ("nextWaypoint")
	
	if (direction == 0):
		if (currentWaypointIndex + 1 == waypoints.size()):
			direction = 1
			currentWaypointIndex -= 1
		else:
			currentWaypointIndex += 1
	else:
		if (currentWaypointIndex == 0):
			direction = 0
			currentWaypointIndex += 1
		else:
			currentWaypointIndex -= 1

	currentWaypointPos = waypoints[currentWaypointIndex].get_global_pos()
	print(currentWaypointPos)
