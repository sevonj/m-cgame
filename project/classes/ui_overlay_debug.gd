## General debug stats overlay

class_name UIOverlayDebug extends UIOverlay

@onready var vbox := VBoxContainer.new()

# General
@onready var lab_scene := create_label()
@onready var lab_num_obj := create_label()
@onready var lab_num_nodes := create_label()
@onready var lab_num_orph := create_label()
# Render
@onready var lab_gpu := create_label()
@onready var lab_fps := create_label()
@onready var lab_objects_in_frame := create_label()
@onready var lab_primitives_in_frame := create_label()
@onready var lab_drawcalls := create_label()
# Mem
@onready var lab_mem := create_label()
@onready var lab_mempeak := create_label()


func _ready():
	super()
	#anchors_preset = Control.PRESET_FULL_RECT
	z_index = 1
	vbox.add_theme_constant_override("separation", 0)
	add_child(vbox)

	vbox.add_child(lab_scene)
	vbox.add_child(lab_num_obj)
	vbox.add_child(lab_num_nodes)
	vbox.add_child(lab_num_orph)

	vbox.add_child(lab_gpu)
	vbox.add_child(lab_fps)
	vbox.add_child(lab_objects_in_frame)
	vbox.add_child(lab_primitives_in_frame)
	vbox.add_child(lab_drawcalls)

	vbox.add_child(lab_mem)
	vbox.add_child(lab_mempeak)


# gdlint: disable=max-line-length
# The nature of this file makes for a reasonable exception to this rule.
func _process(_delta):
	#visible = Globals.debug_stats_overlay
	if !visible:
		return

	lab_scene.text = str("scene:               ", _get_scene())
	lab_num_obj.text = str(
		"objects:             ", Performance.get_monitor(Performance.OBJECT_COUNT)
	)
	lab_num_nodes.text = str(
		"nodes:               ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	)
	lab_num_orph.text = str(
		"orphan nodes:        ", Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	)
	lab_gpu.text = str("video:               ", OS.get_video_adapter_driver_info())
	lab_fps.text = str("fps:                 ", Engine.get_frames_per_second())
	lab_objects_in_frame.text = str(
		"objects in frame:    ", Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	)
	lab_primitives_in_frame.text = str(
		"primitives in frame: ",
		Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	)
	lab_drawcalls.text = str(
		"draw calls:          ",
		Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	)
	lab_mem.text = str("mem:                 ", String.humanize_size(OS.get_static_memory_usage()))
	lab_mempeak.text = str(
		"mem peak:            ", String.humanize_size(OS.get_static_memory_peak_usage())
	)
	#lab_mempeak.text =				str("mem peak:            ", Performance.get_monitor(Performance.TIME_FPS))


func _get_scene() -> String:
	var scene := get_tree().current_scene
	if !is_instance_valid(scene):
		return "N/A"
	return scene.scene_file_path
