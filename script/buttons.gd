extends VBoxContainer

@export var i:int
var button
var scrollok
# Called when the node enters the scene tree for the first time.
func _ready():
	scrollok = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	button = self.get_child(i)
	button.grab_focus()
	if scrollok:
		if Input.is_action_just_pressed("up"):
			if i == 0:
				i = get_child_count()
			if i > 0:
				i -= 1
#			print(i)
		if Input.is_action_just_pressed("down"):
			if i < get_child_count() + 1:
				i += 1
			if i == get_child_count():
				i = 0
#			print(i)
