@tool
class_name TerrainGen

const width = 2048
const height = 1024
const grid_size = 64

static func generate_terrain(noise_img: Image, shape_img: Image) -> Terrain:
	shape_img.resize(width, height)

	var grid_w: int = width / grid_size
	var grid_h: int = height / grid_size

	var world_off := Vector2(width * -.5, -height)
	var terrain := Terrain.new()

	for y in grid_h:
		for x in grid_w:
			# Create texture
			var pos : Vector2 = Vector2(x, y) * grid_size
			var rect := Rect2(pos, Vector2.ONE * grid_size)

			var cell_img := get_cell_img(noise_img, shape_img, rect)

			# Create grid cell
			var cell = WorldCell.new()

			# Add cell to world
			terrain.add_child(cell)
			cell.position = pos + world_off
			cell.name = "cell_%s_%s" % [x, y]
			cell.build_from_img(cell_img)

	return terrain


static func get_cell_img(noise_img: Image, shape_img: Image, area: Rect2) -> Image:
	var cell_img = Image.create(area.size.x, area.size.y, false, Image.FORMAT_RGBA8)

	for y in range(area.size.y):
		for x in range(area.size.x):
			var noise := noise_img.get_pixel(x + area.position.x, y + area.position.y)
			var shape := shape_img.get_pixel(x + area.position.x, y + area.position.y)
			var sample := noise# * shape
			if pow(sample.r * 2 + .1, 2) < .5:
				sample.a = 0.
			cell_img.set_pixel(x, y, sample)

	return cell_img


static func create_noise_tex() -> NoiseTexture2D:
	var noise_tex := NoiseTexture2D.new()
	noise_tex.generate_mipmaps = false
	noise_tex.width = TerrainGen.width
	noise_tex.height = TerrainGen.height
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.fractal_octaves = 3
	noise.frequency = .003
	noise.seed = randi()
	noise_tex.noise = noise

	# You need to await one frame!
	_load_texture_to_gpu(noise_tex)
	return noise_tex


# HACK: This loads the texture to gpu, because get_image() pulls the image from there and returns
# null if it isn't there.
static func _load_texture_to_gpu(texture: Texture2D) -> void:
	var dummy := Sprite2D.new()
	dummy.texture = texture
	dummy.free()
