extends Camera2D




@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 4

# Текущий и целевой масштаб
var target_zoom: Vector2

func _ready():
	# Устанавливаем начальный масштаб камеры
	target_zoom = zoom

func _process(delta):
	# Плавное приближение к целевому масштабу
	zoom = lerp(zoom, target_zoom, 0.1)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		target_zoom -= Vector2(zoom_speed, zoom_speed)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		target_zoom += Vector2(zoom_speed, zoom_speed)
	
	# Ограничение масштаба
	target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
