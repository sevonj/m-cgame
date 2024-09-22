## Debug overlay for drawing temporary 2D things on screen.
##
## Call this directly if you have 2D screen coords, or through camera rig if you have 3D world
## coords.
##

class_name UIOverlayDebugdraw extends Node2D

const _DEFAULT_COLOR = Color.ORANGE

var _points: Array[DebugDrawPoint] = []
var _lines: Array[DebugDrawLine] = []

#region Virtual Methods

func _ready() -> void:
	z_index = 2100


func _process(delta):
	# Remove expired points
	var points_filtered: Array[DebugDrawPoint] = []
	for point in _points:
		# Comparison before subtraction to show for one frame if duration is 0.
		if point.time_left >= 0:
			points_filtered.append(point)
		point.time_left -= delta
	_points = points_filtered

	# Remove expired lines
	var lines_filtered: Array[DebugDrawLine] = []
	for line in _lines:
		# Comparison before subtraction to show for one frame if duration is 0.
		if line.time_left >= 0:
			lines_filtered.append(line)
		line.time_left -= delta
	_lines = lines_filtered

	queue_redraw()


# Built-in draw method.
# Don't call directly, use queue_redraw().
func _draw() -> void:
	for line in _lines:
		draw_line(line.start, line.end, line.color, 1.)

	for point in _points:
		draw_rect(point.rect, point.color, false)

#endregion

#region API

## Draw a point on screen.
func add_point(point: Vector2, duration := 3., color := _DEFAULT_COLOR) -> void:
	_points.append(DebugDrawPoint.new(point, duration, color))


## Draw a line on screen.
func add_line(start: Vector2, end: Vector2, duration := 3., color := _DEFAULT_COLOR) -> void:
	_lines.append(DebugDrawLine.new(start, end, duration, color))


## Draw a rectangle on screen.
func add_rect(rect: Rect2, duration := 3., color := _DEFAULT_COLOR) -> void:
	var start := rect.position
	var end := rect.end
	_lines.append(DebugDrawLine.new(Vector2(start.x, start.y), Vector2(start.x, end.y), duration, color))
	_lines.append(DebugDrawLine.new(Vector2(start.x, end.y), Vector2(end.x, end.y), duration, color))
	_lines.append(DebugDrawLine.new(Vector2(end.x, end.y), Vector2(end.x, start.y), duration, color))
	_lines.append(DebugDrawLine.new(Vector2(end.x, start.y), Vector2(start.x, start.y), duration, color))

#endregion

#region Subclasses

class DebugDrawPoint:
	extends RefCounted
	const RECT_SIZE = Vector2(
		8.,
		8,
	)
	const RECT_OFF = -RECT_SIZE / 2
	var rect: Rect2
	var time_left: float
	var color: Color

	func _init(pos: Vector2, time: float, col: Color):
		rect = Rect2(pos + RECT_OFF, RECT_SIZE)
		time_left = time
		color = col


class DebugDrawLine:
	extends RefCounted
	var start: Vector2
	var end: Vector2
	var time_left: float
	var color: Color

	func _init(_start: Vector2, _end: Vector2, time: float, col: Color):
		start = _start
		end = _end
		time_left = time
		color = col

#endregion
