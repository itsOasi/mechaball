extends Node3D

signal scored
var scoreOk:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.get_name() == "ball" and scoreOk:
		emit_signal("scored")
		print("somebody scored")
