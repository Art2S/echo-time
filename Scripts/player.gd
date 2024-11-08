class_name Player extends CharacterBody2D



var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $Player_sprite
@onready var state_machine: PlayerStateMachine = $StateMachine


func _ready() -> void:
	$ShadowSprite.modulate.a = 0.5
	state_machine.Initialize(self)
	
	pass

func _physics_process(_delta):
	# ТП для удобства (на клавишу ё)
	if Input.is_action_pressed("TELEPORT"):
		$"../Player".position = Singleton.mouse_pos
	
	# Ходьба
	move_and_slide()
	
func _process(_delta: float) -> void:
	#Вектор для ходьбы
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

func _input(event):
	if event is InputEventMouseMotion:
		Singleton.mouse_pos = get_global_mouse_position()

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	
	# Отзеркаливание
	#player_sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true



func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"
