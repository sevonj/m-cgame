class_name WorldCell
extends Node2D

#region Public vars
var debugdraw := true
## Smaller number generates more accurate polygons.
var collision_epsilon := 4.0
#endregion

#region Private vars
## Collision Bitmap
var _bitmap: BitMap
## Contains one coord from each hole found in the bitmap.
## Used for slicing the bm because coll generation doesn't support holes.
var _bitmap_holes: Array[Vector2i]
## Polygon Collider
var _collider: StaticBody2D
##
var _coll_polygons: Array[PackedVector2Array]
## Image for _tex
var _img: Image
## Texture for _visual
var _tex: ImageTexture
## Visual Instance
var _visual: Sprite2D
#endregion

# --- Code

#region Virtual Methods

func build_from_img(image: Image) -> void:
	_img = image
	_tex = ImageTexture.create_from_image(image)

	_bitmap = BitMap.new()
	_bitmap.create_from_image_alpha(_img)

	_create_visual()

	_update_cell()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if debugdraw:
		_debugdraw()

func _enter_tree() -> void:
	pass #texture = texture

func _exit_tree() -> void:
	pass #if is_instance_valid()

#endregion

#region Setup Methods

func _create_visual() -> void:
	if is_instance_valid(_visual):
		_visual.queue_free()

	_visual = Sprite2D.new()
	_visual.texture = _tex
	add_child(_visual)
	_visual.position = _tex.get_size() * .5

	if false:
		_visual.modulate = Color(
			randf_range(.3, .7),
			randf_range(.3, .7),
			randf_range(.3, .7)
			)
	else:
		_visual.modulate = Color(.6, .2, .1)

#endregion

#region Update Methods

func _update_cell() -> void:
	var t_begin := Time.get_ticks_msec()
	_bitmap_holes = BitMapUtil.find_enclosed_holes(_bitmap)
	var t_holes := Time.get_ticks_msec()
	_rebuild_collisions(_bitmap)
	var t_coll := Time.get_ticks_msec()
	BitMapUtil.to_img_alpha(_bitmap, _img)
	var t_texture := Time.get_ticks_msec()
	_tex.set_image(_img)


	print("%s Cell Updated. Time Spent:" % t_begin)
	print("Holes:    %s ms" % (t_holes - t_begin))
	print("Colls:    %s ms" % (t_coll - t_holes))
	print("Textures: %s ms" % (t_texture - t_coll))
	print("Total:    %s ms" % (t_texture - t_begin))

	print("holecount: %s" % _bitmap_holes.size())


## Refresh collisions from bitmap
## TODO: This is a performance bottleneck.
func _rebuild_collisions(bitmap: BitMap) -> void:
	var size := bitmap.get_size()

	# Remove old collider
	if is_instance_valid(_collider):
		_collider.free()
	_coll_polygons.clear()

	# Create new collider
	_collider = StaticBody2D.new()
	add_child(_collider)
	_collider.name = "_collider"

	# Generate polygons
	var num_holes = _bitmap_holes.size()

	if num_holes == 0:
		var rect = Rect2(Vector2.ZERO, bitmap.get_size())
		_coll_polygons = _bitmap.opaque_to_polygons(rect, 4.0)

	else:
		# 1D array
		var holes: Array[int]= [0, size.x]
		for coord in _bitmap_holes:
			holes.append(coord.x)
		holes.sort()

		# Create vertical slices
		var prev := 0
		for hole_x in holes:
			if hole_x == prev:
				continue

			var start := Vector2(prev, 0)
			var end := Vector2(hole_x, size.y)
			var rect := Rect2(start, end)
			prev = hole_x

			# Generate polygons and add offset
			var x_offset := rect.position.x
			var new_polygons: Array[PackedVector2Array] = []
			for polygon in _bitmap.opaque_to_polygons(rect, 4.0):
				var new_polygon: PackedVector2Array = []
				for point in polygon:
					point.x += x_offset
					new_polygon.append(point)
				new_polygons.append(new_polygon)
			_coll_polygons += new_polygons


	# Add polygons to collider
	for polygon in _coll_polygons:
		var new_poly = CollisionPolygon2D.new()
		new_poly.polygon = polygon
		_collider.add_child(new_poly)



func _build_collision_area(rect: Rect2) -> void:
	# Generate polygons and add offset
	var x_offset := rect.position.x
	var new_polygons: Array[PackedVector2Array] = []
	for polygon in _bitmap.opaque_to_polygons(rect, 4.0):
		var new_polygon: PackedVector2Array = []
		for point in polygon:
			point.x += x_offset
			new_polygon.append(point)
		new_polygons.append(new_polygon)

	# Add polygons to collider
	for polygon in _coll_polygons:
		var new_poly = CollisionPolygon2D.new()
		new_poly.polygon = polygon
		_collider.add_child(new_poly)

	_coll_polygons += new_polygons


#endregion

# #region Utility Methods
#
# # Under Construction
#func _bitmap_update_holes() -> void:
#	var hole_coords: Array[Vector2i] = []
#
#	if _bitmap.get_true_bit_count() < 4:
#		_bitmap_holes = hole_coords
#		return
#
#	var size = _bitmap.get_size()
#	var visited := _bitmap.duplicate()
#
#	for y in size.y:
#		for x in size.x:
#			if not visited.get_bit(x, y):
#				var hole_coord := Vector2i(x, y)
#				if _bitmap_check_hole(hole_coord, visited, Color(randf(),randf(),randf())):
#					hole_coords.push_back(hole_coord)
#
#	_bitmap_holes = hole_coords
#
#
# # This utility method flood-fills a BitMap from a selected pixel and determines if it belongs to an
# # enclosed hole (within this cell only).
# # NOTICE: Check the start bit before calling this.
# # WARNING: This will write the filled area into the "visited" BitMap.
#func _bitmap_check_hole(start: Vector2i, visited: BitMap, color: Color = Color.RED) -> bool:
#	var size = _bitmap.get_size()
#
#	var coord_stack: Array[Vector2i] = [start]
#	var is_hole := true # Turned to false if edge contact.
#
#	# -- Debug
#	var img := _texture.get_image()
#	var cell_size := _bitmap.get_size()
#	# -- end
#
#	while not coord_stack.is_empty():
#		var coord = coord_stack.pop_back()
#
#		# 1px offset in each cardinal direction
#		var neighbor_coords: Array[Vector2i] = [
#			Vector2i(coord.x - 1, coord.y),
#			Vector2i(coord.x + 1, coord.y),
#			Vector2i(coord.x, coord.y - 1),
#			Vector2i(coord.x, coord.y + 1)
#			]
#
#		visited.set_bit(coord.x, coord.y, true)
#		img.set_pixel(coord.x, coord.y, color)
#
#		if coord.x == 0 or coord.y == 0 or coord.x == size.x - 1 or coord.y == size.y - 1:
#			is_hole = false
#
#		for neighbor in neighbor_coords:
#			if neighbor.x < 0 or neighbor.y < 0 or neighbor.x >= size.x or neighbor.y >= size.y:
#				continue
#			if visited.get_bit(neighbor.x, neighbor.y):
#				continue
#
#			coord_stack.push_back(neighbor)
#
#	# -- Debug
#	#_texture.set_image(img)
#	# -- end
#
#	return is_hole
#
# #endregion


#region API
## Holemap: Set bits to true to remove them
## Offset: offset of holemap relative to this cell
func cut_hole(holemap: BitMap, offset: Vector2) -> void:
	var cell_size := _bitmap.get_size()
	var hole_size := holemap.get_size()

	for y in cell_size.y:
		for x in cell_size.x:
			var hole_x: int = x - offset.x
			var hole_y: int = y - offset.y

			# Skip if these cell bm coords are out of bounds for hole bm.
			if hole_x < 0 or hole_y < 0 or hole_x >= hole_size.x or hole_y >= hole_size.y :
				continue

			if holemap.get_bit(hole_x, hole_y):
				_bitmap.set_bit(x, y, false)

	_update_cell()


#endregion

func _debugdraw() -> void:
	for poly in _coll_polygons:
		for i in range(poly.size() - 1):
			var start: Vector2 = poly[i] + global_position
			var end: Vector2 = poly[i+1] + global_position
			UiDebugdraw.add_line(start, end, 0.)

func _debug_flash_hit() -> void:
	modulate *= 2.
	await get_tree().create_timer(.2).timeout
	modulate *= .5
