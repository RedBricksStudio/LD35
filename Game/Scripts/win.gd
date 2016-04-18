extends Node

var player
onready var s = ResourceLoader.load("res://Scenes/End/End.scn")
export var win_location = Vector2(100, 100)
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	set_process(true)

func _process(delta):
	player = get_node("/root/Node2D/Player")
	if player != null and player.get_pos().distance_to(win_location) < 10:
		print("You won!")
		# Instance the new scene
		current_scene.free()
		current_scene = s.instance()
		
		# Add it to the active scene, as child of root
		get_tree().get_root().add_child(current_scene)
		
		# optional, to make it compatible with the SceneTree.change_scene() API
		get_tree().set_current_scene(current_scene)
		