class_name Terrain
extends Node2D

@export var noise_tex: NoiseTexture2D

var width = 2048
var height = 1024

var grid_size = 256


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_tree() -> void:
	pass#_generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_noise() -> void:
	# Noisetex
	noise_tex = NoiseTexture2D.new()
	noise_tex.width = width
	noise_tex.height = height
