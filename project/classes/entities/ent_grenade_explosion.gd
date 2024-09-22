class_name EntGrenadeExplosion
extends StaticBody2D

var fuse := 5.

const col_radius := 14
const tex_cut := preload("res://assets/weapons/texx_wpn_grenade_cut.png")

func _ready() -> void:
	_setup_visual()
	explode.call_deferred()


func _setup_visual() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = tex_cut
	add_child(sprite)


func explode() -> void:
	var t_begin := Time.get_ticks_msec()



	var query := PhysicsShapeQueryParameters2D.new()
	var shape := RectangleShape2D.new()
	shape.size = tex_cut.get_size()
	query.shape = shape
	query.transform = transform
	var hits = get_world_2d().direct_space_state.intersect_shape(query, 8192)

	_debugdraw_aabb(Rect2(query.transform.origin - shape.size / 2., shape.size))

	var debug_cell_count := 0

	var colliders = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider not in colliders:
			colliders.append(collider)

	for collider in colliders:
		if not collider.get_parent().has_method("cut_hole"):
			continue

		var cell_pos: Vector2 = collider.global_position
		var offset := global_position - cell_pos - tex_cut.get_size() / 2.

		var hole_bitmap = BitMap.new()
		hole_bitmap.create_from_image_alpha(tex_cut.get_image())

		collider.get_parent().cut_hole(hole_bitmap, offset)
		debug_cell_count += 1
	queue_free()

	var t_end := Time.get_ticks_msec()

	print("%s Explosion hit %s cells and took %s ms to process." % [t_begin, debug_cell_count, t_end - t_begin])



func _debugdraw_aabb(rect: Rect2) -> void:
	UiDebugdraw.add_rect(rect, 3., Color.ORANGE_RED)
