extends Control

var host = ENetMultiplayerPeer.new()
var ipList = IP.get_local_addresses()

var player_info = {}

var my_info

@export var ip:String



func _ready():
#	get_tree().connect("network_peer_connected", _player_connected)
#	%ServerList.visible = false
	ip = ipList[1]

func _player_connected(id):
	print(str(id) +" connected to server!")
	#Game on!
	hide()
	rpc_id(id, "register_player", plyrObj.ID)
	$"/root".add_child($"/root/globals".map)

func _on_Host_button_down():
	print(ip)
#	$ServerNameEnter.visible = true
#	$ServerNameEnter.active = true
	%ServerNameEnter/serverName.grab_focus()
	%menu/Join.hide()
	%menu/Host.disabled = true
	%menu.i = $menu.get_child_count() -1
	%menu.scrollok = false
	get_tree().set_network_peer(host)

func _on_Join_button_down():
#	$ServerList.visible = true
#	$ServerList/List.refresh()
	$menu/Host.hide()
	$menu/Join.disabled = true
	$menu.i = $menu.get_child_count() -1
	$menu.scrollok = false

func _on_Back_button_down():
	get_tree().set_network_peer(null)
	print("connection closed")
	get_tree().change_scene_to_file("res://scenes/ChooseMatch.tscn")

func createServer():
	print(plyrObj.ID + " is hosting network: " + ip)
	var res = host.create_server(4242, 2)
	if res != OK:
		print("Error creating server")
		_on_Join_button_down()
		return
