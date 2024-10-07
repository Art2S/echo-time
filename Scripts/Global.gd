extends Node

signal fps_displayed(value)
signal bloom_toggled(value)
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)




func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
	Singleton.game_data.fullscreen_on = toggle
	Singleton.save_settings()
	
	
func toggle_vsync(toggle):
	OS.vsync_enabled = toggle
	Singleton.game_data.vsync_on = toggle
	Singleton.save_settings()
	
	
func toggle_fps_display(toggle):
	emit_signal("fps_displayed", toggle)
	Singleton.game_data.display_fps = toggle
	Singleton.save_settings()
	
	
func set_max_fps(value):
	Engine.target_fps = value if value < 500 else 0
	Singleton.game_data.max_fps = Engine.target_fps if value < 500 else 500
	Singleton.save_settings()
	
	
func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	Singleton.game_data.bloom_on = value
	Singleton.save_settings()
	
	
func update_brightness(value):
	emit_signal("brightness_updated", value)
	Singleton.game_data.brightness = value
	Singleton.save_settings()
	
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	Singleton.game_data.master_vol = vol
	Singleton.save_settings()
	
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	
		
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	
	
func update_fov(value):
	emit_signal("fov_updated", value)
	Singleton.game_data.fov = value
	Singleton.save_settings()
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
	Singleton.game_data.mouse_sens = value
	Singleton.save_settings()
