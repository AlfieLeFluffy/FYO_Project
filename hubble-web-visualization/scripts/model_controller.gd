@tool
extends Node3D

@export_category("CutPlane Information")
@export var meshes: Array[MeshInstance3D]
@export var cutplane: MeshInstance3D
@export var collision_shapes: Array[CollisionShape3D]

var last_transform

func _ready() -> void:
	Globals.S_UPDATE_COLLISION_SHAPES.connect(update_collision_shape)
	Globals.S_SET_CROSS_SECTION_DISTANCE.connect(set_cutplane_distance)
	Globals.S_SET_CROSS_SECTION_ANGLE.connect(set_cutplane_angle)
	set_shader_parameters(cutplane.transform)
	last_transform = cutplane.transform

func _process(delta: float) -> void:
	if cutplane.transform != last_transform:
		set_shader_parameters(cutplane.transform)
		last_transform = cutplane.transform

func set_cutplane_distance(distance: float):
	cutplane.position.z = distance
	
func set_cutplane_angle(angle: float):
	cutplane.rotation.y = angle

func set_shader_parameters(trans) -> void:
	for mesh in meshes:
		mesh.material_override.set_shader_parameter("cutplane", trans)
		mesh.material_override.next_pass.set_shader_parameter("cutplane", trans)

func update_collision_shape() -> void:
	var state: bool = not is_visible_in_tree()
	for shape in collision_shapes:
		shape.disabled = state
