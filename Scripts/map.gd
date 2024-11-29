extends Node2D


func _on_area_2d_body_entered(_body: Player) -> void: # Убедимся, что это игрок
	call_deferred("change_scene")

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Dungeon.tscn")
