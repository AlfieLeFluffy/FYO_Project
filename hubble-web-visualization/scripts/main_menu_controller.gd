extends MenuBar

@export_category("Menus")
@export var menu_popup: PopupMenu
@export var models_popup: PopupMenu
@export var view_popup: PopupMenu

var init_pos_cross: Vector2
var init_pos_wave: Vector2
var init_pos_info: Vector2

func _ready() -> void:
	init_pos_cross = %CrossSectionWindow.position
	init_pos_wave = %WaveLengthWindow.position
	init_pos_info = %InformationWindow.position
	Globals.S_OPEN_INFORMATION.connect(open_information_popup)
	Globals.S_RESET_INFORMATION.connect(_on_information_window_close_requested)

func _on_menu_index_pressed(index: int) -> void:
	match index:
		0:
			%CrossSectionWindow.visible = false
			%WaveLengthWindow.visible = false
			%InformationWindow.visible = false
			%CrossSectionWindow.set_deferred("position",init_pos_cross)
			%WaveLengthWindow.set_deferred("position",init_pos_wave)
			%InformationWindow.set_deferred("position",init_pos_info)
			Globals.switch_model(0)
			Globals.S_SET_CROSS_SECTION_DISTANCE.emit(8.0)
			Globals.S_SET_CROSS_SECTION_ANGLE.emit(0.0)
	match index:
		1:
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _on_models_index_pressed(index: int) -> void:
	Globals.switch_model(index)

func _on_view_index_pressed(index: int) -> void:
	match index:
		0:
			var check = not view_popup.is_item_checked(index)
			view_popup.set_item_checked(index, check)
			Globals.S_TOGGLE_REFERENCE_VISIBILITY.emit(check)
		1:
			var check = not view_popup.is_item_checked(index)
			view_popup.set_item_checked(index, check)
			Globals.S_TOGGLE_INFORMATION_VISIBILITY.emit(check)
		2:
			var check = not view_popup.is_item_checked(index)
			view_popup.set_item_checked(index, check)
			Globals.S_TOGGLE_LIGHT_PATHS_VISIBILITY.emit(check)
		4:
			%CrossSectionWindow.visible = not %CrossSectionWindow.visible
			%CrossSectionWindow.set_deferred("position",init_pos_cross)
			Globals.S_SET_CROSS_SECTION_DISTANCE.emit(8.0)
			Globals.S_SET_CROSS_SECTION_ANGLE.emit(0.0)
		5:
			%WaveLengthWindow.visible = not %WaveLengthWindow.visible
			%WaveLengthWindow.set_deferred("position",init_pos_wave)

func open_information_popup(resource: InformationResource) -> void:
	%InformationWindow.set_deferred("position",init_pos_info)
	%InformationWindow.title = resource.ref_name
	%InformationLabel.text = resource.ref_desc
	%InformationWindow.popup()

func _on_cross_section_slider_value_changed(value: float) -> void:
	Globals.S_SET_CROSS_SECTION_DISTANCE.emit(value)

func _on_angle_section_slider_value_changed(value: float) -> void:
	Globals.S_SET_CROSS_SECTION_ANGLE.emit(value)

func _on_information_window_close_requested() -> void:
	Globals.S_RESET_WAVELENGTH.emit()
	%InformationWindow.visible = false

func _on_wave_length_window_close_requested() -> void:
	%WaveLengthWindow.visible = false

func _on_cross_section_window_close_requested() -> void:
	%CrossSectionWindow.visible = false
	Globals.S_SET_CROSS_SECTION_DISTANCE.emit(8.0)
	Globals.S_SET_CROSS_SECTION_ANGLE.emit(0.0)
