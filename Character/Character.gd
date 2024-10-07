extends KinematicBody

const SPEED = 3

export var SPEED_TURN = 0.005
export var SPEED_MOVE = 0
export var SPEED_FALL = 0.3
export var SPEED_JUMP = 7

var speed_animations = {
	'run' : 2
}
export var state_cam = 'idle_1'
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
		SPEED_MOVE = -1
	if Input.is_action_pressed("down"):
		SPEED_MOVE = -1
	if Input.is_action_pressed("left"):
		SPEED_MOVE = -1
	if Input.is_action_pressed("right"):
		SPEED_MOVE = -1
	
	
	if Input.is_action_just_pressed("view"):
		if Singleton.view == 'first':
			Singleton.view = 'third'
		elif Singleton.view == 'third':
			Singleton.view = 'first'
	
	if Input.is_action_pressed("run"):
		state_body = 'run'
		if Singleton.view == 'first':
			state_cam = 'run_1'
		elif Singleton.view == 'third':
			state_cam = 'run_3'
			

	
	
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			vel.y = SPEED_JUMP
	
	if SPEED_MOVE:
		vel.z = SPEED_MOVE * SPEED
		vel = vel.rotated(Vector3.UP, rotation.y)
	
	
		if not Input.is_action_pressed("run"):
			state_body = 'move'
			if Singleton.view == 'first':
				state_cam = 'move_1'
			elif Singleton.view == 'third':
				state_cam = 'move_3'
	else:
		state_body = 'idle'
		if Singleton.view == 'first':
			state_cam = 'idle_1'
		elif Singleton.view == 'third':
			state_cam = 'idle_3'
	
	
	vel = move_and_slide(vel, Vector3.UP, false, 4, 0.785398, false)
	
	if Input.is_action_pressed("Z"):
		state_body = 'Z'
	
	
	if $Player_body/Animation_Player.current_animation != state_body:
		if speed_animations.has(state_body):
			$Player_body/Animation_Player.playback_speed = speed_animations[state_body]
		else:
			$Player_body/Animation_Player.playback_speed = 1
		$Player_body/Animation_Player.play(state_body)
		
		
