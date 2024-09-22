extends Node2D


@onready var world: Node2D = $world
var terrain: Terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_generate()

func _generate():
	if is_instance_valid(terrain):
		terrain.free()

	var noise_tex := TerrainGen.create_noise_tex()
	await get_tree().process_frame
	var noise_img = noise_tex.get_image()
	var shape_img: Image = Image.load_from_file("res://assets/terrain_gen/shapes/2hill.png")
	terrain = TerrainGen.generate_terrain(noise_img, shape_img)
	world.add_child(terrain)
	terrain.name = "terrain"
