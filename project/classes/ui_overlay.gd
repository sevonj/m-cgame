## Base class for debug ovelays

class_name UIOverlay extends MarginContainer

var lab_sb := StyleBoxFlat.new()


func _init():
	lab_sb.bg_color = Color(0., 0., 0., .5)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready():
	anchors_preset = PRESET_FULL_RECT


## Create a debug label with dark bg
func create_label(text := "") -> Label:
	var lab = Label.new()
	lab.add_theme_stylebox_override("normal", lab_sb)
	lab.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	lab.text = text
	return lab


func create_vbox() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_theme_constant_override("separation", 0)
	return vbox


func create_hbox() -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_theme_constant_override("separation", 0)
	return hbox
