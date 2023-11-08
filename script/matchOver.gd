extends Control

var betText:int

var p1Text:String
var p2Text:String

# Called when the node enters the scene tree for the first time.
func setText():
	$Panel/scores/p1.text = p1Text
	$Panel/scores/bet.text = str(betText)
	$Panel/scores/p2.text = p2Text
	
	$Panel/Button.grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	get_parent().goHome()
