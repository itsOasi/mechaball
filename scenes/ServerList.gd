extends ColorRect

var button = preload("res://objects/Button.tscn").instantiate()

var i:int
var active
var item

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		item = get_child(i)
		item.grab_focus()
		if Input.is_action_just_pressed("ui_down"):
			i += 1
			if i > get_child_count() - 1:
				i = 0
		if Input.is_action_just_pressed("ui_up"):
			i -= 1
			if i < 0:
				i = get_child_count() -1
		if Input.is_action_just_pressed("ui_left"):
			item.focus_mode = Control.FOCUS_NONE
		if Input.is_action_just_pressed("ui_right"):
			item.focus_mode = Control.FOCUS_ALL

func refresh():
	pass

func _on_Button_button_down():
	refresh()
