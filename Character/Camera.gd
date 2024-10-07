extends Camera

var target = null

func _ready():
	Singleton.camera = self

func _process(delta):
	if target:
		transform.origin = transform.origin.linear_interpolate(target.transform.origin + target.cam_pos.rotated(Vector3.UP, target.rotation.y), 10 * delta)
		transform.basis = Basis(transform.basis.get_rotation_quat().slerp(target.transform.basis.get_rotation_quat(), 10 * delta))
		
		

func upd_target(t):
	target = t

