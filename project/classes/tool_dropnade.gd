class_name ToolDropnade
extends Node2D

const tex := preload("res://assets/weapons/tex_wpn_grenade.png")

func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = tex
	add_child(sprite)


func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("fire"):
		var grenade := WpnGrenade.new()
		get_tree().root.get_node("main/entities").add_child(grenade)
		grenade.global_position = get_global_mouse_position()
