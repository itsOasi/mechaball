extends RigidBody3D

#puppet func setPosition(pos):
#	position = pos

#func _physics_process(delta):
#	rpc_unreliable("setPosition",Vector3(position.x, position.y, position.z))   
func _ready():
	linear_velocity = Vector3.ZERO
	
func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		%AudioStreamPlayer.play()
	if body.get_name() != "Player":
		%AudioStreamPlayer2.play()

func hold():
	print("holding ball")
	freeze = true
	linear_velocity = Vector3.ZERO

func release():
	freeze = false
	linear_velocity = Vector3.ZERO

func dribble(pos, strgth):
	var t = get_tree().create_tween()
	if position != pos:
		t.tween_property(self, "position", pos, .01)
#	apply_central_force(position.direction_to(pos) * strgth * 10)

func kicked(from, strgth):
	print("ball kicked")
	apply_central_force(-from.global_transform.basis.z * strgth * 10)
