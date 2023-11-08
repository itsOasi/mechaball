extends Control

var host = ENetMultiplayerPeer.new()

var b3 = preload("res://scenes/BestOf3.tscn")
#var b5 = preload("res://scenes/BestOf5.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", lobby._player_connected)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_B3_button_down():
	$"/root/globals".map = b3.instantiate()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_B5_button_down():
#	$"/root/globals".map = b5.instantiate()
#	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	pass


func _on_Practice_button_down():
	lobby.visible = false
	get_tree().change_scene_to_file("res://scenes/Practice.tscn")

func _on_back_button_down():
	get_tree().change_scene_to_file("res://scenes/Home.tscn")
