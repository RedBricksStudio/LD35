extends Sprite

func _ready():
	set_process(true)
	add_to_group("enemies")
	add_to_group("talkable")

func _process(delta):
	pass

func _being_talked(other):
	get_node("/root/Node2D").dialog_change("Hello")