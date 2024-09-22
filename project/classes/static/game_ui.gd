## GameUI - A static class
##
## Purpose:
## Manages (static) UI elements.

class_name GameUI

# Instance preloads.
#const _PAUSEMENU = preload("res://ui/pausemenu/pausemenu.tscn")
#const _HUD = preload("res://ui/hud/hud.tscn")

# Nodes:
# All UI overlays should be under this node.
# Adding this node to the tree is autoload's job.
static var _root := _create_ovl_root()
static var _temp_overlays: Array[Node] = []  # Cleared at scene change
static var _ui_pausemenu: Control
static var _ui_hud: Control
static var _ui_overlay_debughelp: UIOverlayDebugHelp  ## Debug keybind helper
static var _ui_overlay_debug: UIOverlayDebug  ## Debug overlay for general stats
static var _ui_overlay_debugdraw: UIOverlayDebugdraw  ## Visualizes lines and points.

# --- Public --- #


# -- Get Overlays
## Returns the ui overlay root node.
static func get_root() -> Node:
	return _root


static func get_ovl_debugdraw() -> UIOverlayDebugdraw:
	return _ui_overlay_debugdraw


#static func set_hud_target(player: Player) -> void:
#	if !is_instance_valid(_ui_hud):
#		push_error("set_hud_target(): Invalid hud instance")
#		return
#	_ui_hud.target = player


# -- Toggles


static func set_mouse_lock(lock: bool) -> void:
	if lock:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


static func set_show_pausemenu(visible: bool) -> void:
	if !is_instance_valid(_ui_pausemenu):
		push_error("show_pausemenu(): Invalid instance")
		return
	_ui_pausemenu.visible = visible


static func set_show_hud(visible: bool) -> void:
	if !is_instance_valid(_ui_hud):
		push_error("show_hud(): Invalid instance")
		return
	_ui_hud.visible = visible


# -- Other


#static func create_gameplay_overlays() -> void:
#	_create_ovl_pausemenu()
#	_create_ovl_hud()


static func create_debug_overlays() -> void:
	_create_ovl_debug()
	_create_ovl_debugdraw()
	_create_ovl_debughelp()


## Add a temporary overlay.
## Temporary means it's freed at scene change.
static func add_scene_overlay(overlay: Node) -> void:
	if !is_instance_valid(overlay):
		push_error("Attempted to add invalid entity!")
		return

	## Unparent if applicable
	if overlay.is_inside_tree():
		overlay.get_parent().remove_child(overlay)

	_root.add_child(overlay)


## Clear temporary overlays.
static func clear_scene_overlays() -> void:
	if is_instance_valid(_ui_hud):
		_ui_hud.queue_free()
	if is_instance_valid(_ui_pausemenu):
		_ui_pausemenu.queue_free()

	for overlay in _temp_overlays:
		if is_instance_valid(overlay):
			overlay.queue_free()
	_temp_overlays.clear()


# --- Private --- #


static func _create_ovl_root() -> Node:
	var ovl := Node.new()
	ovl.name = "ui"
	return ovl


#static func _create_ovl_pausemenu():
#	if is_instance_valid(_ui_pausemenu):
#		_ui_pausemenu.queue_free()
#	_ui_pausemenu = _PAUSEMENU.instantiate()
#	_root.add_child(_ui_pausemenu)


#static func _create_ovl_hud():
#	if is_instance_valid(_ui_hud):
#		_ui_hud.queue_free()
#	_ui_hud = _HUD.instantiate()
#	_root.add_child(_ui_hud)


static func _create_ovl_debugdraw():
	_ui_overlay_debugdraw = UIOverlayDebugdraw.new()
	_root.add_child(_ui_overlay_debugdraw)


static func _create_ovl_debug():
	_ui_overlay_debug = UIOverlayDebug.new()
	_root.add_child(_ui_overlay_debug)


static func _create_ovl_debughelp():
	_ui_overlay_debughelp = UIOverlayDebugHelp.new()
	_root.add_child(_ui_overlay_debughelp)
