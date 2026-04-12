extends Node3D

@export var earth_material: MeshInstance3D
@export var light: DirectionalLight3D

func _ready():
	# Find the DirectionalLight in the parent scene
	var light = find_light_source()
	if light:
		update_light_direction(light)

func find_light_source() -> DirectionalLight3D:
	return light

func update_light_direction(light: DirectionalLight3D):
	# Calculate the light direction (negative Z-axis of the light's transform)
	var light_direction = light.global_transform.basis.z
	earth_material.mesh.material.set_shader_parameter("light_direction", light_direction)

func _physics_process(delta):
	# Optionally, update the light direction dynamically in case the light moves
	var light = find_light_source()
	if light:
		update_light_direction(light)
