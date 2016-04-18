extends Node

var player
onready var s = ResourceLoader.load("res://Scenes/End/End.scn")
export var win_location = Vector2(100, 100)

func _ready():
	set_process(true)

func _process(delta):
	player = get_node("/root/Node2D/Player")
	if player != null and player.get_pos().distance_to(win_location) < 10:
		print("You won!")
		# Instance the new scene
		var current_scene = s.instance()
		
		# Add it to the active scene, as child of root
		get_tree().get_root().add_child(current_scene)
		
		# optional, to make it compatible with the SceneTree.change_scene() API
		get_tree().set_current_scene(current_scene)