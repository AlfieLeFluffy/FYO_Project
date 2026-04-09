extends DirectionalLight3D

@export var sun: Node3D

func _physics_process(delta: float) -> void:
	if not sun:
		return
	look_at(-sun.global_position, Vector3.UP)
