extends Control

var tween_low: Tween
var tween_high: Tween

func _ready() -> void:
	Globals.S_RESET_WAVELENGTH.connect(reset_wavelenghts)
	Globals.S_SET_WAVELENGTH.connect(update_wavelengths)
	reset_wavelenghts()

func reset_wavelenghts() -> void:
	var resource: InformationResource = InformationResource.new()
	resource.ref_name = ""
	resource.wavelength_low = 1
	resource.wavelength_high = 2500
	update_wavelengths(resource)
	
func update_wavelengths(resource: InformationResource) -> void:
	var lowstring = "%.0f" % resource.wavelength_low
	var highstring = "%.0f" % resource.wavelength_high
	if resource.ref_name != "":
		%WavelengthLabel.text = "Wavelength Range of [b]"+resource.ref_name+"[/b]:\nLow: [b]"+lowstring+"nm[/b]\nHigh: [b]"+highstring+"nm[/b]"
	else:
		%WavelengthLabel.text = "Wavelength Range:\nLow: [b]"+lowstring+"nm[/b]\nHigh: [b]"+highstring+"nm[/b]"
	
	if tween_low:
		if tween_low.is_running():
			await tween_low.finished
	if tween_low:
		if tween_high.is_running():
			await tween_high.finished
	
	tween_low = create_tween()
	tween_low.set_ease(Tween.EASE_IN_OUT)
	tween_low.tween_property(%WavelengthLeft, ^"value", resource.wavelength_low, 0.8)
	tween_high = create_tween()
	tween_high.set_ease(Tween.EASE_IN_OUT)
	tween_high.tween_property(%WavelengthRight, ^"value", %WavelengthRight.max_value - resource.wavelength_high, 0.8)
