extends Node


func _ready():
	Singleton.game = self
	Singleton.pausee(0)
	
	if Singleton.has_saves:
		$World/Player.translation.x = Singleton.save_player_pos_x
		$World/Player.translation.y = Singleton.save_player_pos_y
		$World/Player.translation.z = Singleton.save_player_pos_z

func _physics_process(delta):
	Singleton.player_pos_x =  $World/Player.translation.x
	Singleton.player_pos_y =  $World/Player.translation.y
	Singleton.player_pos_z =  $World/Player.translation.z

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Singleton.pausee()
		Singleton.sub("menu_pause")
