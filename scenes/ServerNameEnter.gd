extends Control

var i:int
var active
var item
# Called when the node enters the scene tree for the first time.
func _ready():
	active = false

func _process(delta):
	if active:
		item = get_child(i)
		item.grab_focus()
		if Input.is_action_just_pressed("ui_right"):
			i += 1
			if i > get_child_count() - 1:
				i = 0
		if Input.is_action_just_pressed("ui_left"):
			i -= 1
			if i < 0:
				i = get_child_count() -1
		if Input.is_action_just_pressed("ui_down"):
			item.focus_mode = Control.FOCUS_NONE
		if Input.is_action_just_pressed("ui_up"):
			item.focus_mode = Control.FOCUS_ALL
func _on_enter_button_down():
	lobby.ip = $serverName.text
	$serverName.editable = false
	item.focus_mode = Control.FOCUS_NONE
	$enter.disabled = true
	lobby.createServer()
