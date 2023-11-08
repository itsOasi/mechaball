extends KinematicBody

export var ID:String
export var stmn:float
export var spd:int
export var jump:int
export var sens:int
export var hlth:float

export var isMoving:bool
export var isCrouching:bool

export var subFac:Vector2
export var grav = 9.8
export var look_limits:Vector2
var direction = Vector3()
var velocity = Vector3()
var lookY = 0
var lookX = 0
var lookXAngle = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	isMoving = false
	if(is_network_master()):
		$stats/hlthStmn/stmn.value = stmn
		$stats/hlthStmn/hlth.value = hlth
		$stats/xpMoneyAmmo/XP.text = str(get_parent().xp)
		$stats/xpMoneyAmmo/Money.text = str(get_parent().money)
		$stats/xpMoneyAmmo/ammo.text = str(get_parent().ammo)
		
		if stmn > 100:
			stmn = 100
		
		if isMoving == false && stmn < 100:
			stmn += subFac.x * 0.5
			if isCrouching:
				stmn += subFac.x * 0.75
		
		#reset movement values
		direction = Vector3(0,0,0)
		lookY = 0
		lookX = 0
		
		#move
		if Input.get_joy_axis(0, 1) > .3 or Input.get_joy_axis(0, 1) < - .3:
			isMoving = true
			if stmn > 0 and !isCrouching:
				direction -= $head.global_transform.basis.z * Input.get_joy_axis(0, 1) * spd * delta
				stmn -= subFac.x
			if isCrouching:
				direction -= $head.global_transform.basis.z * Input.get_joy_axis(0, 1) * (spd * 0.25) * delta
				stmn -= subFac.x
			if stmn <= 0 and hlth > 1 and !isCrouching:
				direction -= $head.global_transform.basis.z * Input.get_joy_axis(0, 1) * (spd * 0.25) * delta
				hlth -= subFac.y
		if Input.get_joy_axis(0, 0) > .3 or Input.get_joy_axis(0, 0) < - .3:
			isMoving = true
			if stmn > 0 and !isCrouching:
				direction -= $head.global_transform.basis.x * Input.get_joy_axis(0, 0) * (spd * 0.75) * delta
				stmn -= subFac.x
			if isCrouching:
				direction -= $head.global_transform.basis.x * Input.get_joy_axis(0, 0) * (spd * (0.25 * 0.75)) * delta
				stmn -= subFac.x * .5
			if stmn <= 0 and hlth > 1 and !isCrouching:
				direction -= $head.global_transform.basis.x * Input.get_joy_axis(0, 0) * (spd * (0.25 * 0.75)) * delta
				hlth -= subFac.y
		#jump
		if(is_on_floor() and Input.is_action_just_pressed("ui_select")):
			isMoving = true
			if stmn > 10 and !isCrouching:
				stmn -= 10
				velocity.y = jump;
				print("jump")
			isCrouching = false
				
		if(is_on_floor() and Input.is_action_just_pressed("ui_cancel")):
			if isCrouching == false:
				print("crouching")
				isCrouching = true
			else:
				print("not crouching")
				isCrouching = false
				
		#horizontal look
		if Input.get_joy_axis(0, 2) > .3 or Input.get_joy_axis(0, 2) < - .3:
			lookY -= Input.get_joy_axis(0, 2) * sens
	
		#vertical look
		if Input.get_joy_axis(0, 3) > .3 or Input.get_joy_axis(0, 3) < - .3:
			lookX += Input.get_joy_axis(0, 3) * sens
		
		#turns head around y axis
		$head.rotate_y(deg2rad(lookY))
		
		#turns head around x axis
		var change = lookX
		if change + lookXAngle < look_limits.x and change + lookXAngle > look_limits.y:
			$head/Camera.rotate_x(deg2rad(change))
			lookXAngle += change
		
		if (velocity.y < 0):
			grav = 30
		
		velocity.y += -grav * delta
		velocity.x = direction.x * spd * delta
		velocity.z = direction.z * spd * delta
		 
		# Tell the other computer about our new position so it can update       
		rpc_unreliable("setPos",Vector3(position.x, position.y, position.z))   
		
		velocity = move_and_slide(velocity, Vector3(0,1,0))

	
slave func setPos(pos = Vector3()):
	position = pos

func _on_Area_body_entered(body):
	if body.get_name() == "bullet":
		var bullet = body
		get_node("/root/playerObject").hlth -= bullet.dmg

func addValues(m, x, s):
	get_parent().money += m
	get_parent().xp += x
	stmn += s