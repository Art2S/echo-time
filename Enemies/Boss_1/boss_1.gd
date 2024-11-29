class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged( hurt_box : HurtBox )
#signal enemy_destroyed( hit_box : HitBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 10
var around_player = false
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false
var alive = true
var vision = false
@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: HitBox = $Interactions/HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var Destroy: EnemyStateDestroy = $EnemyStateMachine/Destroy
@onready var Death: EnemyStateDeath = $EnemyStateMachine/Death
@onready var attack: EnemyStateAttack = $EnemyStateMachine/Attack
@onready var stun: EnemyStateStun = $EnemyStateMachine/Stun


# Called when the node enters the scene tree for the first time.
func _ready():
	$HP_bar.max_value = hp
	$HP_bar.value = hp
	$shadow.modulate.a = 0.5
	state_machine.initialize( self )
	player = PlayerManager.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	move_and_slide()


func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round(
			( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.RIGHT else 1
	return true


func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func take_damage(damage) -> void:
	if invulnerable == true:
		return
	hp -= damage
	$HP_bar.value = hp
	
	if hp <= 0:
		alive = false
		state_machine.change_state(Destroy)
	elif hp > 0:
		$AudioStreamPlayer2D.play()
		state_machine.change_state(stun)
	

func _on_hurt_box_damaged(damage: int) -> void:
	take_damage(damage)




#Область, когда босс бьет
func _on_hit_area_body_entered(_body: Player) -> void:    #Область, когда босс начинает атаковать
	if alive:
		around_player = true
		state_machine.change_state(attack)
	


func _on_hit_area_body_exited(_body: Player) -> void:
	if alive:
		around_player = false

#Область видимости босса
func _on_vision_area_player_entered() -> void:
	if alive:
		vision = true


func _on_vision_area_player_exited() -> void:
	if alive:
		vision = false
		state_machine.change_state(state_machine.get_state("Idle"))
