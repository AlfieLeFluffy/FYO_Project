class_name UIReference extends Node3D

enum REFERENCE_TYPE {
	INFORMATION,
	ACTION_VISIBILITY
}

const symbols: Dictionary = {
	REFERENCE_TYPE.INFORMATION: "+",
	REFERENCE_TYPE.ACTION_VISIBILITY: "*"
}

@export_category("Reference Information")
@export var ref_type: REFERENCE_TYPE = REFERENCE_TYPE.INFORMATION
@export var ref_resource: InformationResource = InformationResource.new()
@export var ref_target: Array[Node3D]

var cont: CenterContainer
var button: Button
var camera: OrbitCamera3D
var raycast: RayCast3D
var visibility: bool = true

func _ready() -> void:
	raycast = RayCast3D.new()
	add_child(raycast)
	Globals.S_TOGGLE_INFORMATION_VISIBILITY.connect(update_visibility)
	setup_button()

func _process(delta: float) -> void:
	if visibility:
		raycast.target_position = camera.position
		raycast.force_raycast_update()
		if is_visible_in_tree():
			if not raycast.is_colliding():
				button.visible = is_visible_in_tree()
				cont.position = camera.unproject_position(global_position)
			else: 
				button.visible = false
		else:
			button.visible = false
	else:
		button.visible = false

func setup_button() -> void:
	cont = CenterContainer.new()
	cont.use_top_left = true
	camera = get_viewport().get_camera_3d()
	button = Button.new()
	button.text = symbols[ref_type]
	button.pressed.connect(popup_information)
	button.mouse_entered.connect(hover_information_enter)
	button.mouse_exited.connect(hover_information_exit)
	button.custom_minimum_size = Vector2(32,32)
	cont.add_child(button)
	get_tree().get_first_node_in_group("UI").add_child(cont)
	cont.position = camera.unproject_position(global_position)

func update_visibility(state: bool) -> void:
	visibility = state

func popup_information() -> void:
	if ref_type != REFERENCE_TYPE.INFORMATION and not ref_target:
		push_error("Missing target for UI_Reference: " + name)
		return
	
	match ref_type:
		REFERENCE_TYPE.INFORMATION:
			Globals.S_OPEN_INFORMATION.emit(ref_resource)
			Globals.S_SET_WAVELENGTH.emit(ref_resource)
		REFERENCE_TYPE.ACTION_VISIBILITY:
			for target in ref_target:
				target.visible = not target.visible

func hover_information_enter() -> void:
	button.text = ref_resource.ref_name

func hover_information_exit() -> void:
	button.text = symbols[ref_type]
