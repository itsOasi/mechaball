extends Control

var current_screen = 0

func _ready():
	%bgm.play()
	igui.hideMenus()
	close_menus()
	%main/Hangar.show()
	
func _process(delta):
	%info/Label.text = "XP: " + str(plyrObj.xp)
	%info/Label2.text = "$: " + str(plyrObj.money)
	%info/Label3.text = plyrObj.ID

func _on_Quit_button_down():
	get_tree().quit()

func close_menus():
	for menu in %main.get_children():
		menu.hide()

func _on_hangar_pressed():
	close_menus()
	print("opening hangar")
	%main/Hangar.show()


func _on_home_pressed():
	close_menus()
	print("opening home")
	%main/Home.show()


func _on_settings_pressed():
	close_menus()
	print("opening settings")
	%main/Settings.show()
