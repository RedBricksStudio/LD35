
extends Node2D

var currentWaypointPos
var speed = 200

func _ready():

	set_process(true)
	currentWaypointPos = get_node("Waypoint").get_pos()
	
func _process(delta):
	
	if (!xReached()):
		xMove(delta)
	
func xReached():
	
	if (abs(get_pos().x - currentWaypointPos.x) <= 1):
		return true;
		
func xMove(delta):
	
	var newPos = get_pos()
	
	if (get_pos().x <= currentWaypointPos.x):
		newPos += speed * delta * Vector2(1, 0)
	else:
		newPos -= speed * delta * Vector2(-1, 0)	
		
	set_pos(newPos)

