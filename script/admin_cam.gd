extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var controlling_character:bool = false
@export_range(1, 1000) var rot_speed: int
@export var move_dir:Vector2
@export var direction:Vector3
@export var look_dir:Vector2
@export var look_limits:Vector2
var look_target
@export var lookXAngle: float

@export var shift:Vector2

func _physics_process(delta):
#	var look_tween = get_tree().create_tween()
#	look_tween.tween_property(self, "rotation", Vector3(rotation.x+look_dir.x, rotation.y+look_dir.y, rotation.z), .4)
	if controlling_character:
		return
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if len(Input.get_connected_joypads()):
		look_dir = Input.get_vector("look_up", "look_down", "look_right", "look_left").normalized() * .01
	
	if look_target:
		look_at(Vector3(look_target.position.x, global_rotation.y, look_target.position.z))
	else:
		rotate_y(deg_to_rad(look_dir.y * (rot_speed*.2)))
		
		#look around x axis
		var change = look_dir.x
		if change + lookXAngle < look_limits.y and change + lookXAngle > -look_limits.x:
			%Camera.rotate_x(deg_to_rad(-change * (rot_speed*.1)))
			lookXAngle += change
		look_dir.x = 0
		look_dir.y = 0

	move_and_slide()
	
func select():
	var hit = %Camera/RayCast3D.get_collider(0)
	if plyrObj.get_children().find(hit) == -1:
		return
	plyrObj.curr_char = hit
	print("selected ", plyrObj.curr_char.get_name())
