## Autoload Debugtools
extends Node

var enabled := true

var tool: Node

func _process(_delta: float) -> void:
	if !enabled:
		return

	if Input.is_action_just_pressed("wpn_select_1"):
		_swap_tool(ToolTestcut.new())
	elif Input.is_action_just_pressed("wpn_select_2"):
		_swap_tool(ToolDropnade.new())


func _clear_tool() -> void:
	if is_instance_valid(tool):
		tool.queue_free()

func _swap_tool(new_tool: Node) -> void:
	_clear_tool()
	tool = new_tool
	get_tree().root.get_node("main/entities").add_child(new_tool)
