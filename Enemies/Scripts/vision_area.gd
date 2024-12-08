class_name VisionArea extends Area2D

signal player_entered()
signal player_exited()

func _ready() -> void:
	# Проверяем, подключен ли уже сигнал 'body_entered'
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	# Проверяем, подключен ли уже сигнал 'body_exited'
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	
	var p = get_parent()
	if p is Enemy:
		# Подключаем сигнал только если он еще не был подключен
		if not p.direction_changed.is_connected(_on_direction_change):
			p.direction_changed.connect(_on_direction_change)

func _on_direction_change(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass

func _on_body_entered(body: Player) -> void:
	if body is Player:
		player_entered.emit()

func _on_body_exited(body: Player) -> void:
	if body is Player:
		player_exited.emit()
