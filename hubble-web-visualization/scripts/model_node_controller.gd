extends Node3D

@export var modelname: String = ""
@export var ref_resourece: InformationResource

func _ready() -> void:
	Globals.S_SWITCH_MODEL.connect(toggle_visiblity)

func toggle_visiblity(_modelname: String) -> void:
	if modelname == _modelname:
		visible = true
	else:
		visible = false
	if ref_resourece and visible:
		Globals.S_OPEN_INFORMATION.emit(ref_resourece)
		Globals.S_SET_WAVELENGTH.emit(ref_resourece)
		Globals.S_UPDATE_COLLISION_SHAPES.emit()
