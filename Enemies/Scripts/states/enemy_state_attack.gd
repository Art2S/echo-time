class_name EnemyStateAttack extends EnemyState

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0

@onready var enemy_state_machine: EnemyStateMachine = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@onready var idle: EnemyStateIdle = $"../Idle"
@onready var wander: EnemyStateWander = $"../Wander"
@onready var chase: EnemyStateChaseAI = $"../Chase"

@onready var hit_box: HitBox = $"../../Interactions/HitBox"




## What happens when the player enters this State?
func enter() -> void:
	if attacking:
		return
	if enemy.around_player:
		
		var selected_animation = ["attack_1", "attack_2"].pick_random()
		var time = 0
		if selected_animation == "attack_1":
			time = 1
		elif selected_animation == "attack_2":
			time = 0.8
		enemy.update_animation(selected_animation)  #удар или рукой или ногой, рандомно
		
		
		if not animated_sprite_2d.animation_finished.is_connected(_end_attack):
			animated_sprite_2d.animation_finished.connect(_end_attack)
		attacking = true

		hit_box.monitoring = true
		hit_box.show()
		await get_tree().create_timer(time).timeout
		hit_box.monitoring = false
		hit_box.hide()
	else:
		state_machine.change_state(chase)

func exit() -> void:
	if animated_sprite_2d.animation_finished.is_connected(_end_attack):
		animated_sprite_2d.animation_finished.disconnect(_end_attack)
	hit_box.monitoring = false
	hit_box.hide()
	hit_box.reset()
	attacking = false


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	
	if not attacking:
		if enemy.around_player:
			enter()
		else:
			return chase

	return null
	

## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> EnemyState:
	return null



func _end_attack() -> void:
	if attacking:
		attacking = false
		hit_box.monitoring = false
		hit_box.hide()
