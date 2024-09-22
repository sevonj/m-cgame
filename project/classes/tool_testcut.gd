class_name ToolTestcut
extends Node2D

const tex := preload("res://assets/terrain_gen/tex_testcut.png")

func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = tex
	add_child(sprite)


func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("fire"):
		_collide()


func _collide():
	var query := PhysicsShapeQueryParameters2D.new()
	var shape := RectangleShape2D.new()
	shape.size = tex.get_size()
	query.shape = shape
	query.transform = transform
	query.transform.origin -= shape.size / 2
	var hits = get_world_2d().direct_space_state.intersect_shape(query, 64)

	var colliders = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider not in colliders:
			colliders.append(collider)

	for collider in colliders:
		print(collider.get_path())

		var cell_pos: Vector2 = collider.global_position
		var offset := global_position - cell_pos - tex.get_size() / 2.

		var hole_bitmap = BitMap.new()
		hole_bitmap.create_from_image_alpha(tex.get_image())

		collider.get_parent().cut_hole(hole_bitmap, offset)
