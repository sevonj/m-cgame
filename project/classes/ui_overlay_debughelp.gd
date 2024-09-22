## This overlay shows keybinds for debug

class_name UIOverlayDebugHelp extends UIOverlay

@onready var vbox := create_vbox()

@onready var _lab_bind_debug := create_label()


func _ready():
	super()
	z_index = 1
	vbox.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_theme_constant_override("separation", 0)
	add_child(vbox)

	vbox.add_child(_lab_bind_debug)


# gdlint: disable=max-line-length
func _process(_delta):
	#visible = Globals.debug_stats_overlay
	if !visible:
		return

	_lab_bind_debug.text = str("[F1] Toggle Debug")
