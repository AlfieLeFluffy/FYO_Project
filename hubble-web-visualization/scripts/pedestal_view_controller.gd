extends Node3D

func _ready() -> void:
	Globals.S_TOGGLE_REFERENCE_VISIBILITY.connect(toggle_references)

func toggle_references(state: bool):
	%References.visible = state
