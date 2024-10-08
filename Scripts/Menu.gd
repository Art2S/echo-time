extends CanvasLayer


onready var settings_menu = $SettingsMenu
onready var start_btn = $Start_Button

func _ready():
	start_btn.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Singleton.pausee(0)



func _on_Start_Button_pressed():
	Singleton.config = ConfigFile.new()
	var error = Singleton.config.load(Singleton.SaveGame)
	if error != OK:
		print("Не удалось загрузить файл конфигурации.")
	else:
		Singleton.has_saves = Singleton.config.has_section_key("Player", "player_position_x")
		
	if Singleton.has_saves == false:
		Singleton.change_scene("res://Scenes/Game.tscn")
		Singleton.save_game()
	elif Singleton.has_saves == true:
		$ColorRect.show()
	



func _on_Settings_Button_pressed():
	settings_menu.popup_centered()


func _on_Load_Button_pressed():
	Singleton.load_game()


func _on_No_Button_pressed():
	$ColorRect.hide()


func _on_Yes_Button_pressed():
	Singleton.delete_save()
	Singleton.change_scene("res://Scenes/Game.tscn")
	#Singleton.save_game()
	


func _on_ExitButton_pressed():
	get_tree().quit()
