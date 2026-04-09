extends Camera3D

"""
Add this script to a Camera and set the camera as a child
of the object you wish to orbit. Set the camera's
translation and rotation to (0,0,0) in the editor and the
script will set the initial distance appropriately.

Enable 'Emulate Touch from Mouse' in Project Settings,
then click-drag to move the camera. Use W/T to zoom
Out/In (Wide/Tight).
"""

@export_group("Orbit Camera Variables")
@export var pitchlimit_degrees: float = 85.0 # must be less than 90
@export var zoomspeed: float = 5.0 # arbitrary
@export var rotspeed: float = 10.0 / 1e5 # arbitrary
@export var mindistance: float = 5.0
@export var maxdistance: float = 30.0
@export var distance: float = clamp(25.0, mindistance, maxdistance) # initialize

@export_group("Camera Orientation")

@export var pitchlim: float = pitchlimit_degrees*PI/180.0
@export var vec2zero: Vector2 = Vector2(0.0, 0.0)
@export var vec3zero: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var turn_up: Vector3 = Vector3(1.0, 0.0, 0.0)

var rot_dy = 0.0
var rot_dx = 0.0
var dz_stack = 0.0
var dz = 0.0

var drag_velocity_rad = vec2zero

func _ready():
	assert (pitchlimit_degrees < 90)
	assert (zoomspeed > 0)
	assert (rotspeed > 0)
	translate_object_local(Vector3(0.0, 0.0, distance)) # initial zoom

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate"):
		drag_velocity_rad += rotspeed*event.velocity
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				dz += 1
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				dz -= 1

func _process(delta):
	if dz_stack:
		dz += zoomspeed*delta*dz_stack
		dz_stack = 0
	translate_object_local(Vector3(0.0, 0.0, -distance)) # temporary zoom in
	rotate_y(-drag_velocity_rad.x) 		# global yaw
	rotate_object_local(turn_up, clamp( # local pitch
			-drag_velocity_rad.y, -pitchlim-rotation.x, pitchlim-rotation.x))
	distance = clamp(distance+dz, mindistance, maxdistance)
	translate_object_local(Vector3(0.0, 0.0, distance)) # zoom back out
	orthonormalize() # repair precision errors
	dz = 0.0
	drag_velocity_rad = vec2zero
