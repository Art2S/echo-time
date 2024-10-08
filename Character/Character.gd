extends KinematicBody

var SPEED = 3

export var MOVE = 0
export var SPEED_FALL = 0.3
export var SPEED_JUMP = 7

var speed_animations = {
	'run' : 2
}

export var state_body = 'idle'

var vel = Vector3()


func _ready():
	Singleton.player = self
	$Player_body/Animation_Player.play(state_body)





func _physics_process(_delta):
	vel.x = 0
	vel.z = 0
	vel.y -= SPEED_FALL
	
	
	if Input.is_action_pressed("up"):
		MOVE = -1
	if Input.is_action_pressed("down"):
		MOVE = -1
	if Input.is_action_pressed("left"):
		MOVE = -1
	if Input.is_action_pressed("right"):
		MOVE = -1
	
	if not Input.is_action_pressed("up"):
		if not Input.is_action_pressed("down"):
			if not Input.is_action_pressed("left"):
				if not Input.is_action_pressed("right"):
					MOVE = 0
	
	
		
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			vel.y = SPEED_JUMP
	
	if MOVE:
		vel.z = MOVE * SPEED
		vel = vel.rotated(Vector3.UP, rotation.y)
		if Input.is_action_pressed("run"):
			state_body = 'run'
			SPEED = 6
		else:
			state_body = 'move'
			SPEED = 3
	else:
		state_body = 'idle'
	
	
	vel = move_and_slide(vel, Vector3.UP, false, 4, 0.785398, false)
	
	if Input.is_action_pressed("Z"): #Пасхалко, простите)
		state_body = 'Z'
	if $Player_body/Animation_Player.current_animation != state_body:
		if speed_animations.has(state_body):
			$Player_body/Animation_Player.playback_speed = speed_animations[state_body]
		else:
			$Player_body/Animation_Player.playback_speed = 1
		$Player_body/Animation_Player.play(state_body)
		
		
