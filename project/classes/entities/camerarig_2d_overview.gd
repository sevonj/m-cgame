class_name Camerarig2DOverview
extends Camera2D

var scroll_speed := Vector2(192., 128)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += _input_cursor_edge() * scroll_speed * delta


## Normal movement; View scrolls when mouse is close to an edge.
func _input_cursor_edge() -> Vector2:
	var deadzone := .6
	var view := get_viewport_rect().size
	var cursor: Vector2 = clamp(get_local_mouse_position() * 2. / view, -Vector2.ONE , Vector2.ONE)
	var input := Vector2.ZERO

	if abs(cursor.x) > deadzone:
		input.x = max(abs(cursor.x) - deadzone, 0) / (1. - deadzone)
		if cursor.x < 0:
			input.x *= -1.

	if abs(cursor.y) > deadzone:
		input.y = max(abs(cursor.y) - deadzone, 0) / (1. - deadzone)
		if cursor.y < 0:
			input.y *= -1.

	return input
