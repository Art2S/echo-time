class_name EnemyStateDestroy extends EnemyState


@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@onready var hp_bar: ProgressBar = $"../../HP_bar"
@onready var Death: EnemyStateDeath = $"../Death"
@onready var hurt_box: HurtBox = $"../../HurtBox"
@export_category("AI")

#@export_category("Item Drops")
#@export var drops : Array[ DropData ]

var _direction : Vector2



## What happens when we initialize this state?
func init() -> void:
	pass

## What happens when the enemy enters this State?
func enter() -> void:
	hp_bar.hide()
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to( enemy.hurt_box.damage_pos ) #аектор для откидывания
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed           #откидывание
	#enemy.animation_player.animation = "destroy"
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animated_sprite_2d_animation_finished )
	disable_hurt_box()
	#state_machine.change_state(Death)
	#drop_items()


## What happens when the enemy exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


func disable_hurt_box() -> void:
	var hurt_box_node : HurtBox = enemy.get_node_or_null("../../HurtBox")
	if hurt_box_node:
		hurt_box.monitoring = false

func _on_animated_sprite_2d_animation_finished():
	state_machine.change_state(Death)


'''
func drop_items() -> void:
	if drops.size() == 0:
		return

	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[ i ].item
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9 , 1.5 )
	pass
'''
