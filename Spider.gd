extends Spatial

onready var targets := get_tree().get_nodes_in_group("targets")
onready var goals := get_tree().get_nodes_in_group("goals")

export(float) var max_dist = 5;

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	for i in range(0, len(goals)):
		if targets[i].global_transform.origin.distance_to(goals[i].global_transform.origin) > max_dist:
			targets[i].global_transform.origin = goals[i].global_transform.origin
			# ($Tween as Tween).interpolate_property(
			# 	targets[i],
			# 	"global_transform/origin",
			# 	null,
			# 	goals[i].global_transform.origin,
			# 	5.0
			# )
			# $Tween.start()
			position_body()


func position_body():
	var average = Vector3.ZERO

	for t in targets:
		average.x += t.translation.x
		average.z += t.translation.z

	average.x /= 4
	average.z /= 4

	translation.x = average.x
	translation.z = average.z
