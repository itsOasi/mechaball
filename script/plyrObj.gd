extends Node3D

var c = preload("res://objects/character.tscn")
var admin_cam:Node3D
var curr_char

@export var ID:String
@export var xp:int
@export var money:int
@export var spd:int
@export var strgth:int
@export var jmpstr:int
@export var sens:int
@export var ball: Node3D
@export var goal: Node3D

func spawn_character(position, rotation_y):
	var character = c.instantiate()
	add_child(character)
	character.ID = ID
	character.SPEED = spd
	character.strgth = strgth
	character.JUMP_VELOCITY = jmpstr
	character.sens = sens
	character.ball = ball
	character.goal = goal
	character.position = position
	character.rotation_degrees.y = rotation_y
#	curr_char = character
#	character.is_player = true

func clear_characters():
	curr_char = null
	for c in get_children():
		c.queue_free()

#Mouse look
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("ui_cancel") and event.echo == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if event is InputEventMouseMotion:
		if curr_char and curr_char.is_player:
			curr_char.look.y -=  event.relative.x * .1 * sens
			curr_char.look.x -=  event.relative.y * -.1 * sens
		elif admin_cam:
			admin_cam.look_dir.y -=  event.relative.x * .04
			admin_cam.look_dir.x -=  event.relative.y * -.04

func _physics_process(delta):
	if curr_char and curr_char.is_player:
		char_logic(delta)
	elif admin_cam:
		admin_logic(delta)

func _process(delta):
	if curr_char:
		admin_cam.controlling_character = curr_char.is_player
		if Input.is_action_just_pressed("control"):
			curr_char.is_player = !curr_char.is_player

func admin_logic(delta):
	var lift = 0
	if Input.is_action_just_released("right_trigger"): 
		admin_cam.select()
	admin_cam.move_dir = Input.get_vector("left", "right", "up", "down")
	lift = Input.get_axis("left_bumper", "right_bumper")
	admin_cam.direction = (admin_cam.transform.basis * Vector3(admin_cam.move_dir.x, lift, admin_cam.move_dir.y)).normalized()

func char_logic(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		curr_char.jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	curr_char.move_dir = Input.get_vector("left", "right", "up", "down")
	if len(Input.get_connected_joypads()):
		curr_char.look = Input.get_vector("look_up", "look_down", "look_right", "look_left") * sens
	curr_char.direction = (curr_char.transform.basis * Vector3(curr_char.move_dir.x, 0, curr_char.move_dir.y)).normalized()
	
	if Input.is_action_pressed("left_trigger"):
			curr_char.plyr_aim()
	
	if Input.is_action_just_released("left_trigger"): 
			curr_char.exit_aim()

	if curr_char.kickOk:
		if Input.is_action_pressed("right_bumper"):
			curr_char.dribble(delta)
			
		if Input.is_action_just_released("right_trigger"):
			curr_char.release()
			curr_char.kick()
	else:
		if Input.is_action_just_released("right_trigger"):
			curr_char.attack()

		
		
			
		if Input.is_action_pressed("back"):
			curr_char.hold()
