extends Spatial

onready var group1 = [
	$targets/frontRightLegTarget,
	$targets/backLeftLegTarget
]

onready var group2 = [
	$targets/frontLeftLegTarget,
	$targets/backRightLegTarget
]

onready var targets := get_tree().get_nodes_in_group("targets")
onready var goals := get_tree().get_nodes_in_group("goals")
onready var origin := translation

onready var y_offset = $targets/frontLeftLegTarget.global_transform.origin.y - global_transform.origin.y

export(float) var max_dist = 0.5;
var time := 0.0
var time_factor := PI/2 
var is_leg_moving = false

func _ready():
	for k in get_tree().get_nodes_in_group("IK"):
		k.start()
	for i in range(0, len(goals)):
		goals[i].global_transform.origin = targets[i].global_transform.origin

func _process(delta):
	if Input.is_action_pressed("move_forward"):
		$goals.translate(Vector3(0, 0, 2 * delta))
	if Input.is_action_pressed("move_backward"):
		$goals.translate(Vector3(0, 0, -2 * delta))
	if Input.is_action_pressed("move_left"):
		$SpiderMesh.rotate_y(1 * delta)
		$goals.rotate_y(1 * delta)
	if Input.is_action_pressed("move_right"):
		$SpiderMesh.rotate_y(-1 * delta)
		$goals.rotate_y(-1 * delta)
	for i in range(0, len(goals)):
		var target_ray: RayCast = targets[i].find_node("RayCast")
		if target_ray.is_colliding():
			targets[i].global_transform.origin.y = target_ray.get_collision_point().y
		position_body()
		if not is_leg_moving and targets[i].global_transform.origin.distance_to(goals[i].global_transform.origin) > max_dist:
			$Tween.interpolate_property(
				targets[i],
				"global_transform:origin:x",
				null,
				goals[i].global_transform.origin.x,
				0.2
			)
			$Tween.interpolate_property(
				targets[i],
				"global_transform:origin:z",
				null,
				goals[i].global_transform.origin.z,
				0.2
			)
			$Tween.start()
			is_leg_moving = true
			yield($Tween, "tween_all_completed")
			is_leg_moving = false

func position_body():
	var average = Vector3.ZERO

	for t in targets:
		average.x += t.translation.x
		average.y += t.translation.y
		average.z += t.translation.z

	average.x /= 4
	average.y /= 4
	average.z /= 4

	$SpiderMesh.translation.x = average.x
	$SpiderMesh.translation.y = average.y + y_offset
	$SpiderMesh.translation.z = average.z
