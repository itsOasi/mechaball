extends Node3D


@export var moneyPool:int

var p1
var p2
var ball
var b = preload("res://objects/Ball.tscn")
var g = preload("res://objects/goal.tscn")
var map
var m

@export var practice:bool

@export var p1score:int
@export var p2score:int

@export var bestof:int

var madeGoal

func _ready():
	%NavigationRegion3D.bake_navigation_mesh()
	igui.connect("reset", _on_igui_reset)
	igui.hideMenus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#create ball
	ball = b.instantiate()
	add_child(ball)
	ball.position = %spawns/ballspwn.position
	ball.hold()
	
	p1 = plyrObj
	p1.admin_cam = %Admin_cam
	p1.ball = ball
	p1.goal = %goalBoxes/goal1
	p1.spawn_character(%spawns/p1spwn.position, %spawns/p1spwn.rotation_degrees.y)
	
	p2 = aiObj
	p2.ball = ball
	p2.goal = %goalBoxes/goal2
	p2.spawn_character(%spawns/p2spwn.position, %spawns/p2spwn.rotation_degrees.y)
	
	if practice:
		igui.p2label = "Practice"
	else:
		igui.p2label = p2.get_name()

	igui.showMenus()

	igui.p1label = p1.ID
	p1score = 0
	p2score = 0

func _physics_process(delta):
#	$Cam.rotate_y(deg_to_rad(.01))
	igui.p1score = p1score
	if bestof > 0:
		igui.time = bestof
	else:
		igui.time = 0
	igui.p2score = p2score
	if p1score == bestof or p2score == bestof:
		gameOver()

func resetScene():
	print("resetting")
	#reset ball
	ball.free()
	
	#create ball
	ball = b.instantiate()
	add_child(ball)
	ball.position = %spawns/ballspwn.position
	ball.hold()
	
	p1.clear_characters()
	p1.curr_char = null
	p1.ball = ball
	p1.goal = %goalBoxes/goal1
	p1.spawn_character(%spawns/p1spwn.position, %spawns/p1spwn.rotation_degrees.y)
	
	p2.clear_characters()
	p2.ball = ball
	p2.goal = %goalBoxes/goal2
	p2.spawn_character(%spawns/p2spwn.position, %spawns/p2spwn.rotation_degrees.y)
	
	madeGoal = false
	%bgm.playing = true

func gameOver():
#	p1.gameOk = false
#	p1.kickOk = false
	igui.hide()
	var scorecard = preload("res://scenes/matchOver.tscn").instantiate()
	add_child(scorecard)
	scorecard.p1Text = str(p1score)
	scorecard.betText = moneyPool
	scorecard.p2Text = str(p2score)
	scorecard.setText()

func _on_goalSound_finished():
	resetScene()

func _on_bgm_finished():
	%bgm.play()
	
func goHome():
	p1.free()
	ball.free()
	queue_free()
#	get_tree().set_network_peer(null)
	print("connection closed")
	get_tree().change_scene_to_file("res://scenes/Home.tscn")


func _on_goal_1_scored():
	p1score += 1
	print("player 1 scored")
	%bgm.playing = false
	%goalSound.play()
	resetScene()


func _on_goal_2_scored():
	p2score += 1
	print("player 2 scored")
	%bgm.playing = false
	%goalSound.play()
	resetScene()


func _on_igui_reset():
	resetScene()
