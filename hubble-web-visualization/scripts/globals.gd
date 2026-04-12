extends Node

@export_category("Models")
@export var models: Array[String] = ["Origin", "Hubble", "Webb"]
@export var initial_model: int = 0
@export var current_model: int = 0

signal S_SWITCH_MODEL(modelname: String)
signal S_UPDATE_COLLISION_SHAPES()
signal S_SET_CROSS_SECTION_DISTANCE(distance: float)
signal S_SET_CROSS_SECTION_ANGLE(angle: float)
signal S_SET_WAVELENGTH(resource: InformationResource)
signal S_RESET_WAVELENGTH()
signal S_OPEN_INFORMATION(resource: InformationResource)
signal S_RESET_INFORMATION()

signal S_TOGGLE_REFERENCE_VISIBILITY(state: bool)
signal S_TOGGLE_INFORMATION_VISIBILITY(state: bool)
signal S_TOGGLE_LIGHT_PATHS_VISIBILITY(state: bool)

func _ready() -> void:
	current_model = initial_model
	Globals.S_SWITCH_MODEL.emit(models[current_model])
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior

func switch_model(index: int):
	if index >= models.size():
		return
	current_model = index
	Globals.S_SWITCH_MODEL.emit(models[current_model])
	if index == 0:
		S_RESET_WAVELENGTH.emit()
		S_RESET_INFORMATION.emit()
