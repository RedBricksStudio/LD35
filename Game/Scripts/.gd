extends Sprite


func _ready():
	set_process(true)

func _process(delta):
	print(get_pos())
	#print(abs(get_pos() - get_node("player").get_pos()))
