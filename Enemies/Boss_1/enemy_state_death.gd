class_name EnemyStateDeath extends EnemyState

@export var exhaust_audio : AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"
@onready var boss_1: Enemy = $"../.."

## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the enemy enters this State?
func enter() -> void:
	#enemy.update_animation("death")
	enemy.animation_player.play( "death" )
	audio.stream = exhaust_audio
	audio.play()
	
	#boss_1.queue_free()
	
	


## What happens when the enemy exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null
