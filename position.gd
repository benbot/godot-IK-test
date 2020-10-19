extends Position3D


func _ready():
	var ray: RayCast = $Ray
	ray.cast_to = Vector3(0, 1, 0)
