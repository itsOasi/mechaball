extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var ID:String
@export var strgth:int
@export var hp: int
@export var stam: float
@export var regen: int
@export var sens:int

@export var move_dir: Vector2
@export var direction: Vector3
@export var is_player: bool = false
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@export var too_high: float
@onready var ray = %head/Foot/RayCast3D

@export var kickOk:bool
@export var gameOk:bool

var current_location

var ball
var has_ball
var goal

var player
var near_player:bool

@export var look_limits:Vector2
@export var look: Vector2
var lookXAngle:float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	var pose_cam = get_tree().create_tween()
	pose_cam.tween_property(%head/Camera, "transform", %head/normal.transform, .2)	

func ai_logic(delta):
	var goal_too_high = nav_agent.target_position.y - self.position.y > too_high or nav_agent.target_position.y - self.position.y < 0;
	var target_dist = nav_agent.distance_to_target()
	if is_player or !ball:
		return
	if kickOk:
		dribble(delta)
	if !has_ball:
		update_target(ball.position)
		ai_nav(delta)
		if target_dist < 70 and goal_too_high and stam > 50:
			jump()
	if has_ball:
		update_target(goal.position)
		ai_nav(delta)
		if target_dist < 70 and goal_too_high and stam > 50:
			jump()
		if nav_agent.distance_to_target() < 50:
			print("kicking ball")
			release()
			kick()

func _physics_process(delta):
	current_location = position
	%head/Camera.current = is_player
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if is_player:
		player_nav(delta)
	else:
		ai_logic(delta)
	if stam <= 100:
		stam += regen * delta

func player_nav(delta):
	current_location = position
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if len(Input.get_connected_joypads()):
		look = Input.get_vector("look_up", "look_down", "look_right", "look_left") * sens
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	
	#look around y axis
	self.rotate_y(deg_to_rad(look.y))
	
	#look around x axis
	var change = look.x
	if change + lookXAngle < look_limits.y and change + lookXAngle > -look_limits.x:
		%head.rotate_x(deg_to_rad(change))
		lookXAngle += change
	look.x = 0
	look.y = 0
	move_and_slide()

func ai_nav(delta):
	current_location = position
	var next_location = nav_agent.get_next_path_position()
	var new_vel = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_vel, .25)
	var change = global_position.direction_to(next_location)
	if change.y < look_limits.y and change.x + lookXAngle > -look_limits.x:
		%head.rotation.x = change.x
	look_at(Vector3(next_location.x, global_position.y, next_location.z))
	move_and_slide()

func update_target(position):
	nav_agent.set_target_position(position)

func jump():
	if is_on_floor() and stam > 30:
		velocity.y += JUMP_VELOCITY
		stam -= 30

func dribble(delta):
	if kickOk and stam > 0:
		has_ball = true
		ball.dribble(%Foot.global_transform.origin, strgth*.8)
	
func hold():
	if kickOk:
		ball.hold()

func plyr_aim():
	if kickOk:
		var pose_cam = get_tree().create_tween()
		ball.release()
		ball.dribble(%head/Foot.global_transform.origin, strgth*.8)
		pose_cam.tween_property(%head/Camera, "transform", %head/shooting.transform, .2)

func release():
	var pose_cam = get_tree().create_tween()
	ball.release()
	pose_cam.tween_property(%head/Camera, "transform", %head/normal.transform, .2)

func kick():
	var pose_cam = get_tree().create_tween()
	if kickOk and stam > 15:
		ball.kicked(%head/Foot, strgth)
		kickOk = false
		has_ball = false
		pose_cam.tween_property(%head/Camera, "transform", %head/normal.transform, .2)
		stam -= 15
		

func _on_Foot_body_entered(body):
	if body.get_name() == "ball":
		kickOk = true

func _on_Range_body_exited(body):
	if body.get_name() == "ball":
		has_ball = false
		kickOk = false
