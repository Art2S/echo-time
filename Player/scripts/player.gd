class_name Player extends CharacterBody2D

@export var fade_duration: float = 3.0  # Время для полного затемнения экрана после смерти
signal direction_changed( new_direction: Vector2 )


@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hit_box : HitBox = $Interactions/HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite : Sprite2D = $Player_sprite
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var death: State_Death = $StateMachine/Death
@onready var hp_bar: ProgressBar = $UI/HpBar


var invulnerable : bool = false
var hp : int = 100
var max_hp : int = 100
var alive = true

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

func _ready() -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hit_box.hide()
	PlayerManager.player = self
	$UI/ColorRect.modulate = Color(1, 0, 0, 0)  # Начальная прозрачность экрана смерти
	$ShadowSprite.modulate.a = 0.5 #полупрозрачность тени
	state_machine.Initialize(self)


func _physics_process(_delta):
	if alive:
		
		# ТП для удобства (на клавишу ё)
		if Input.is_action_pressed("TELEPORT"):
			$"../Player".position = Singleton.mouse_pos
		
		# Тест смерти (на клавишу T)
		if Input.is_action_pressed("death(test)"):
			state_machine.ChangeState(death)
			alive = false
		
		# Ходьба
		move_and_slide()
	
func _process(_delta):
	#Вектор для ходьбы
	if alive:
		direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down")
		).normalized()

func _input(event):
	if event is InputEventMouseMotion:
		Singleton.mouse_pos = get_global_mouse_position()

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	return true



func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func take_damage( damage ) -> void:
	if invulnerable == true:
		return
	hp = hp - damage
	hp_bar.value = hp
	if hp<=0:
		alive = false
		state_machine.ChangeState(death)


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hurt_box.monitoring = false
	$Player_sprite.modulate.a = 0.5
	await get_tree().create_timer( _duration ).timeout
	invulnerable = false
	hurt_box.monitoring = true


func revive_player() -> void:   #пока нет в игре
	alive = true
	hp = 100
	state_machine.change_state( $StateMachine/Idle )



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death_down" or anim_name == "death_side" or anim_name == "death_up":
		$UI/Death_label.show()
		$UI/Back_to_menu_button.show()
		$UI/ColorRect.show()
		hp_bar.hide()
		
		# Плавное затемнение экрана смерти
		var tween := create_tween()
		tween.tween_property($UI/ColorRect, "modulate:a", 1.0, fade_duration)
		tween.play()


func _on_hurt_box_damaged(damage: int) -> void:
	take_damage(damage)
