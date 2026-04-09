class_name OrbitComponent extends Node3D

@export_category("Orbit Infromation")
@export var speed = PI / 256
@export var pivot_point: Node3D = null
@export var object: Node3D = null

func _ready() -> void:
	if not object:
		object = get_parent()

func _physics_process(delta: float) -> void:
	rotate_around(pivot_point.global_position, Vector3.UP, speed * delta)

func rotate_around(pivot, axis, angle):
	object.global_transform.origin -= pivot
	object.global_transform = object.global_transform.rotated(axis, angle)
	object.global_transform.origin += pivot
