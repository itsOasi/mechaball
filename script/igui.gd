extends CanvasLayer

var p1score:int
var p2score:int
var p1label:String
var p2label:String
var time:int

signal reset

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hideMenus()


func _process(delta):
	if plyrObj.get_children():
		%HBoxContainer/stam.text = str(plyrObj.get_child(0).stam)
	%HBoxContainer/p1label.text = p1label
	%HBoxContainer/p1.text = str(p1score)
	%HBoxContainer/time.text = str(time)
	%HBoxContainer/p2.text = str(p2score)
	%HBoxContainer/p2label.text = p2label
	
func showMenus():
	print("showing menus")
	visible = true

func hideMenus():
	print("hiding menus")
	visible = false


func _on_button_pressed():
	print("resetting")
	emit_signal("reset")
