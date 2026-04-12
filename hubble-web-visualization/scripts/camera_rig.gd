extends Node3D

@export_group("Targeting")
@export var targets: Dictionary[String, Node3D] = {}
@export var init_target: String = ""

@export_group("Rig Offset")
@export var max_y: float = 10
@export var min_y: float = -1
@export var yspeed: float = 0.0001

var dy:float = 0.0
var current_target: Node3D = null
var moving: bool = false
var tween: Tween = null

func _ready() -> void:
	if init_target != "":
		if init_target in targets:
			current_target = targets[init_target]
	Globals.S_SWITCH_MODEL.connect(move_camera_rig)

func _physics_process(delta: float) -> void:
	if tween:
		await tween.finished
		tween = null
		dy = 0
	if current_target:
		self.global_position = current_target.global_position + Vector3(0,dy,0)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_camera_rig") and event is InputEventMouseMotion:
		dy += event.velocity.y * yspeed
		dy = min(max_y, max(min_y, dy))

func move_camera_rig(_modelname: String) -> void:
	move_to_target(_modelname)

func move_to_target(target: String):
	if not target in targets:
		return
	if targets[target] == current_target:
		return
	
	dy = 0
	if tween:
		tween.kill()
	
	var distance = targets[target].position.distance_to(current_target.position)
	distance = clamp(distance/2, 1, 3)
	current_target = targets[target] 
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, ^"position", current_target.global_position, distance) 
