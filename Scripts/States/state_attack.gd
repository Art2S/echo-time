class_name State_Attack extends State

var attacking :bool = false

@export_range(1,20,0.5) var decelerate_speed : float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var walk: State = $"../walk"
@onready var idle: State_Idle = $"../idle"

func Enter() -> void:
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect(EndAttack)
	attacking = true
	pass


func Process( _delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	pass

func Physics(_delta : float ) -> State:
	return null

func HandleInput( _event: InputEvent ) -> State:
	return null

func EndAttack( _newAnimName : String ) -> void:
	attacking = false
