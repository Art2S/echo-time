extends Node

const SaveData = "user://Echo_Settings.save"
const SaveGame = "user://Echo_SaveGame.save"

var game_data = {}
var game_save = {}
var config
var is_pause :bool = false
var player = null
var camera = null
var game = null
var pause = 0
var view = 'first'

var save_player_pos_x :float
var save_player_pos_y :float
var save_player_pos_z :float

var player_pos_x :float
var player_pos_y :float
var player_pos_z :float

var has_saves = false

func _ready():
	OS.center_window()
	load_settings()



func load_settings():
	var file = File.new()
	if not file.file_exists(SaveData):
		game_data = {
			"fullscreen_on": true,
			"vsync_on": false,
			"display_fps": true,
			"max_fps": 0,
			"bloom_on": false,
			"brightness": 0.5,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10,
			"fov": 70,
			"mouse_sens": 0.15,
		}
		save_settings()
	file.open(SaveData, File.READ)
	game_data = file.get_var()
	file.close()
	
func save_settings():
	var file = File.new()
	file.open(SaveData, File.WRITE)
	file.store_var(game_data)
	file.close()
	

func load_game():
	config = ConfigFile.new()
	config.load(SaveGame)
	
	save_player_pos_x = config.get_value("Player", "player_position_x", player_pos_x)
	save_player_pos_y = config.get_value("Player", "player_position_y", player_pos_y)
	save_player_pos_z = config.get_value("Player", "player_position_z", player_pos_z)
	
	has_saves = true
	change_scene("res://Scenes/Game.tscn")
	
	
	
func save_game():
	has_saves = true
	config = ConfigFile.new()
	config.set_value("Player", "player_position_x", player_pos_x)
	config.set_value("Player", "player_position_y", player_pos_y)
	config.set_value("Player", "player_position_z", player_pos_z)
	config.save(SaveGame)

func delete_save():
	config.clear()
	has_saves = false


func change_scene(scene_name):
	get_tree().change_scene(scene_name)

func pausee(a):
	is_pause = a
	get_tree().paused = is_pause
	

func sub(s):
	var n = load("res://Scenes/"+s+".tscn").instance()
	game.add_child(n)
