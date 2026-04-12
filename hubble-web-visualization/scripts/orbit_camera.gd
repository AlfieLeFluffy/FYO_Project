class_name OrbitCamera3D extends Camera3D

@export_group("Orbit Camera Variables")
@export var pitchlimit_degrees_up: float = -1.0 # must be less than 90
@export var pitchlimit_degrees_down: float = 85.0 # must be less than 90
@export var zoomspeed: float = 5 # arbitrary
@export var rotspeed: float = 5.0 / 1e5 # arbitrary
@export var mindistance: float = 5.0
@export var maxdistance: float = 30.0
@export var distance: float = clamp(25.0, mindistance, maxdistance)
@export var reset_distance: float = clamp(20, mindistance, maxdistance)

@export_group("Camera Orientation")

@export var pitchlimup: float = pitchlimit_degrees_up*PI/180.0
@export var pitchlimdown: float = pitchlimit_degrees_down*PI/180.0
@export var vec2zero: Vector2 = Vector2(0.0, 0.0)
@export var vec3zero: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var turn_up: Vector3 = Vector3(1.0, 0.0, 0.0)

var rot_dy = 0.0
var rot_dx = 0.0
var dzstack = 0.0
var dz = 0.0

var drag_velocity_rad = vec2zero

func _ready():
	assert (pitchlimit_degrees_up < 90)
	assert (pitchlimit_degrees_down < 90)
	assert (zoomspeed > 0)
	assert (rotspeed > 0)
	translate_object_local(Vector3(0.0, 0.0, distance)) # initial zoom
	Globals.S_SWITCH_MODEL.connect(update_orbit_camera)

func update_orbit_camera(_modelname: String) -> void:
	dz = 0
	dzstack = 0
	if reset_distance-distance  > 0:
		dzstack += reset_distance-distance

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate"):
		drag_velocity_rad += rotspeed*event.velocity
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				dz += 1
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				dz -= 1

func _physics_process(delta: float) -> void:
	if dzstack != 0:
		dz += dzstack/2
		dzstack = dzstack/2
	if dzstack <= 0.1:
		dzstack = 0
	dz += zoomspeed*delta*dz
	translate_object_local(Vector3(0.0, 0.0, -distance)) # temporary zoom in
	rotate_y(-drag_velocity_rad.x) 		# global yaw
	rotate_object_local(turn_up, clamp( # local pitch
			-drag_velocity_rad.y, -pitchlimdown-rotation.x, pitchlimup-rotation.x))
	distance = clamp(distance+dz, mindistance, maxdistance)
	translate_object_local(Vector3(0.0, 0.0, distance)) # zoom back out
	orthonormalize() # repair precision errors
	drag_velocity_rad = vec2zero
	dz = 0
