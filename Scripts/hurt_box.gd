class_name HurtBox extends Area2D

signal damaged(damage: int)
var damage_pos :Vector2


func take_damage(hit_box: HitBox) -> void:
	if hit_box.monitoring and not hit_box.has_hit:
		hit_box.has_hit = true
		damage_pos = hit_box.global_position
		damaged.emit(hit_box.damage)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		take_damage(area)
