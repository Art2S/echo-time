extends Position3D

export(NodePath) var target_node
var target
var camera
var rot_y = 0

func _ready():
	target = get_node(target_node)
	camera = $Camera


func _process(delta):
	transform.origin = target.transform.origin + Vector3(0,1,0)

	
	if Input.is_action_pressed("up"):
		rot_y = rotation.y
	if Input.is_action_pressed("down"):
		rot_y = rotation.y - PI
	if Input.is_action_pressed("left"):
		rot_y = rotation.y + PI/2
	if Input.is_action_pressed("right"):
		rot_y = rotation.y - PI/2
	
	
	if not Input.is_action_pressed("up"):
		if not Input.is_action_pressed("down"):
			if not Input.is_action_pressed("left"):
				if not Input.is_action_pressed("right"):
					target.SPEED_MOVE = 0
	if target.SPEED_MOVE:
		target.transform.basis = Basis(target.transform.basis.get_rotation_quat().slerp(Basis(Vector3.UP, rot_y).get_rotation_quat(), 5 * delta))
	
	if $Detector.is_colliding():
		camera.transform.origin.z = $Detector.get_collision_point().distance_to(global_transform.origin) - 0.5
	else:
		camera.transform.origin.z = 4
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * 0.01
		rotation.x = clamp(rotation.x - event.relative.y * 0.01, -1, 0.1)
		
