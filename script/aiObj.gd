extends Node3D

var c = preload("res://objects/character.tscn")
var character
@export var hive:Node3D

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
	character = c.instantiate()
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

func clear_characters():
	for c in get_children():
		c.queue_free()
				
			
		
	
