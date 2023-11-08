extends LineEdit

# Declare member variables here. Examples:
@export var menu:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	text = plyrObj.ID

func _on_text_changed(new_text):
	plyrObj.ID = new_text
