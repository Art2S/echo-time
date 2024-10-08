extends Control


"""
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Singleton.save_settings()
		Singleton.pausee(0)
		queue_free()
"""

func _on_Exit_Button_pressed():
	get_tree().quit()


func _on_Settings_Button_pressed():
	$SettingsMenu.popup_centered()


func _on_Continie_Button_pressed():
	Singleton.save_settings()
	Singleton.pausee(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_Save_Button_pressed():
	Singleton.save_game()
	$Main_menu/Save_Button/GameSave_Label.show()
	$Main_menu/Save_Button/GameSave_Label/Timer.start()


func _on_Timer_timeout():
	$Main_menu/Save_Button/GameSave_Label.hide()


func _on_Exit_Menu_Button_pressed():
	Singleton.change_scene("res://Scenes/Menu.tscn")
