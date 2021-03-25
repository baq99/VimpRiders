extends Spatial

func _ready():
	var interface = ARVRServer.find_interface('OVRMobile')
	if interface and interface.initialize():
		get_viewport().arvr = true
	
	Engine.iterations_per_second = 72 # Quest
