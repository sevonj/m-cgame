class_name WpnGrenade
extends RigidBody2D

var fuse := 5.

const col_radius := 14
const tex := preload("res://assets/weapons/tex_wpn_grenade.png")

func _ready() -> void:
	_setup_visual()
	_setup_collider()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fuse -= delta
	if fuse < 0:
		explode()

func _setup_collider() -> void:
	var collider := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = col_radius
	collider.shape = shape
	add_child(collider)


func _setup_visual() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = tex
	add_child(sprite)


func explode() -> void:
	var explosion := EntGrenadeExplosion.new()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()
