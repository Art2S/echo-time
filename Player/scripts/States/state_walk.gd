class_name State_Walk extends State

@export var speed : float = 100.0
@onready var idle: State = $"../idle"
@onready var attack: State_Attack = $"../Attack"


func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

func Exit() -> void:
	pass

func Process( _delta : float ) -> State:
	if Input.is_action_pressed("shift"):
		speed = 160
	else:
		speed = 100
	
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * speed
	if player.set_direction():
		player.UpdateAnimation("walk")
	return null

func Physics(_delta : float ) -> State:
	return null

func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
