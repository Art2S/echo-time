class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0


@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var state_machine: PlayerStateMachine = $".."
@onready var idle : State = $"../idle"
@onready var walk : State = $"../walk"
@onready var hit_box: HitBox = $"../../Interactions/HitBox"




## What happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect(_end_attack)
	attacking = true

	# Включаем хитбокс сразу, чтобы он был активен в нужный момент
	hit_box.monitoring = true
	hit_box.show()

	# Создаем таймер для отключения хитбокса (зависит от длины анимации удара)
	await get_tree().create_timer(0.1).timeout  # Настройте тайминг на момент удара
	hit_box.monitoring = false
	hit_box.hide()


func Exit() -> void:
	animation_player.animation_finished.disconnect( _end_attack )
	hit_box.monitoring = false
	hit_box.hide()
	hit_box.reset()
	attacking = false


## What happens during the _process update in this State?
func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


## What happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func Handle_input( _event: InputEvent ) -> State:
	return null



func _end_attack( _newAnimName : String ) -> void:
	attacking = false
	hit_box.monitoring = false
	hit_box.hide()
	state_machine.ChangeState( idle )
