extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	#First create ourself
	var thisPlayer = get_parent().get_child(0)
	thisPlayer.spawnPlayer($spawns/Position3D.position)
	thisPlayer.set_name(str(get_tree().get_network_unique_id()))
	thisPlayer.set_network_master(get_tree().get_network_unique_id())
	add_child(thisPlayer)
  
#Now create the other player
	var otherPlayer = get_parent().get_child(0)
	otherPlayer.spawnPlayer($spawns/Position3D2.position)
	otherPlayer.set_name(str(globals.otherPlayerId))
	otherPlayer.set_network_master(globals.otherPlayerId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
