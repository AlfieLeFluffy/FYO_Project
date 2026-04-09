extends Node3D

@export_group("Targeting")
@export var targets: Dictionary[String, Node3D] = {}
@export var init_target: String = ""

var current_target: Node3D = null
var new_target: Node3D = null
var moving: bool = false
var tween: Tween = null

func _ready() -> void:
	if init_target != "":
		if init_target in targets:
			current_target = targets[init_target]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not moving:
		if event.key_label == KEY_1:
			move_to_target("Origin")
		if event.key_label == KEY_2:
			move_to_target("Hubble")
		if event.key_label == KEY_3:
			move_to_target("Webb")

func _physics_process(delta: float) -> void:
	if current_target and not moving:
		self.global_position = current_target.global_position
	if moving:
		await tween.finished
		moving = false
		current_target = new_target

func move_to_target(target: String):
	if not target in targets or moving:
		return
	if targets[target] == current_target:
		return
	
	moving = true
	new_target = targets[target] 
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, ^"position", new_target.global_position, 1.0) 
	
