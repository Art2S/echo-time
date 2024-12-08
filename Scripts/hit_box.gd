class_name HitBox extends Area2D

@export var damage: int = 1

var has_hit: bool = false

func reset():
	has_hit = false
