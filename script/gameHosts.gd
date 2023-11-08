extends ColorRect

	print("Joining network")
	host.create_client(ip, 4242)
	get_tree().set_network_peer(host)