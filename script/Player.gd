extends CharacterBody3D

@export var ID:String
@export var strgth:int
@export var sens:int

@export var kickOk:bool
@export var gameOk:bool
var ball

@export var grav:float
var direction = Vector3()
#var velocity = Vector3()
@export var look_limits:Vector2
var look = Vector2()
var lookXAngle:float

# Called when the node enters the scene tree for the first time.
func _ready():
	gameOk = true
	kickOk = false
	$head/Camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Mouse look
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.scancode == KEY_ESCAPE and event.echo == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		look.y -=  event.relative.x * .1 * sens
		look.x -=  event.relative.y * -.1 * sens


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = Vector3(0,0,0)
	
	if gameOk == true: #and is_network_master():
		#KB n M
		#movement
		if Input.is_action_pressed("ui_up"):
			direction +=  $head.global_transform.basis.z * -1 * spd * delta
			if Input.is_action_pressed("ui_up") and Input.is_action_pressed("L2"):
				direction +=  $head.global_transform.basis.z * -1 * (spd * 1.125) * delta
		if Input.is_action_pressed("ui_down"):
			direction +=  $head.global_transform.basis.z * 1 * spd * delta
		if Input.is_action_pressed("ui_right"):
			direction += $head.global_transform.basis.x * 1 * spd * delta
		if Input.is_action_pressed("ui_left"):
			direction += $head.global_transform.basis.x * -1 * spd * delta
		
		#CONTROLLER
		#movement
		if Input.get_joy_axis(0, 1) > .3 or Input.get_joy_axis(0, 1) < - .3:
			direction +=  $head.global_transform.basis.z * Input.get_joy_axis(0, 1) * spd * delta
			if Input.get_joy_axis(0, 1) < -.3 and Input.is_action_pressed("L2"):
				direction +=  $head.global_transform.basis.z * Input.get_joy_axis(0, 1) * (spd * 1.125) * delta
		if Input.get_joy_axis(0, 0) > .3 or Input.get_joy_axis(0, 0) < - .3:
			direction += $head.global_transform.basis.x * Input.get_joy_axis(0, 0) * spd * delta
		#look
		if (Input.get_joy_axis(0, 2) > .3 or Input.get_joy_axis(0, 2) < - .3):
			look.y -= Input.get_joy_axis(0, 2) * sens
		if Input.get_joy_axis(0, 3) > .3 or Input.get_joy_axis(0, 3) < - .3:
			look.x -= Input.get_joy_axis(0, 3) * sens
			
		#jumping
		if(is_on_floor() and Input.is_action_just_pressed("ui_select")):
			velocity.y = jmpstr;
			print("jump")
		
		if kickOk:
			if Input.is_action_pressed("R1"):
				ball.hold()
				
			if Input.is_action_just_released("R1"): 
				ball.release()
				
			if Input.is_action_pressed("R2"):
				ball.dribble($Foot.global_transform.origin, strgth)
				
			if Input.is_action_just_released("R2"):
				kickOk = false
				ball.kicked(global_transform.basis.z, strgth)
				
		#look around y axis
		rotate_y(deg_to_rad(look.y))
		
		#look around x axis
		var change = look.x
		if change + lookXAngle < look_limits.x and change + lookXAngle > look_limits.y:
			$head.rotate_x(deg_to_rad(change))
			lookXAngle += change
		
		look.x = 0
		look.y = 0
		
		if velocity.y < 0:
			grav = 30
			
		
		# Tell the other computer about our new position so it can update       
#		rpc_unreliable("setPosition", Vector3(position.x, position.y, position.z))   

		
	velocity.x = direction.x * spd * delta
	velocity.y += -grav * delta
	velocity.z = direction.z * spd * delta
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))


func _on_Foot_body_entered(body):
	if body.get_name() == "ball":
		print("has ball")
		ball = body
		kickOk = true

func _on_Range_body_exited(body):
	if body.get_name() == "ball":
		kickOk = false

#slave func setPosition(pos):
#	position = pos
