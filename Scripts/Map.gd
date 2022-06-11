extends Node2D
signal tile_over
signal tile_out
signal tile_clicked
signal bldg_built
var wid = 25

var currently_building = ""
var orig_drag_pos:Vector2
var dragging = false
var mouse_pos:Vector2
var tiles = []
enum TileType {
	LAKE,
	FOREST,
	CITY,
}

func _ready():
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 65
	var tree_noise = OpenSimplexNoise.new()
	tree_noise.seed = randi()
	tree_noise.octaves = 1
	tree_noise.period = 150
	var city_noise = OpenSimplexNoise.new()
	city_noise.seed = randi()
	city_noise.octaves = 1
	city_noise.period = 150
	for j in wid:
		for i in wid:
			var level:float = noise.get_noise_2d(i / float(wid) * 512, j / float(wid) * 512)
			var tree_level:float = tree_noise.get_noise_2d(i / float(wid) * 512, j / float(wid) * 512)
			var city_level:float = city_noise.get_noise_2d(i / float(wid) * 512, j / float(wid) * 512)
			var t_id = i % wid + j * wid
			var tile = {}
			if level > 0.5:#If lake
				$TileMap.set_cell(i, j, 1)
				tile = {"type":TileType.LAKE}
			else:
				$TileMap.set_cell(i, j, 0)
			if tree_level > 0.5 and level < 0.5:
				var tree = preload("res://Scenes/Trees.tscn").instance()
				add_child(tree)
				tree.position = Vector2(i, j) * 64 + Vector2(32, 32)
				tile = {"type":TileType.FOREST}
			if city_level > 0.5 and tree_level < 0.5 and level < 0.5:
				var city = preload("res://Scenes/City.tscn").instance()
				add_child(city)
				city.position = Vector2(i, j) * 64 + Vector2(32, 32)
				tile = {"type":TileType.CITY}
			tiles.append(tile)
	$Camera2D.position = Vector2.ONE * wid * 64 / 2.0

func _process(delta):
	if OS.get_latin_keyboard_variant() == "AZERTY":
		if Input.is_action_pressed("Z"):
			$Camera2D.position.y -= 20 * $Camera2D.zoom.x
		elif Input.is_action_pressed("Q"):
			$Camera2D.position.x -= 20 * $Camera2D.zoom.x
	else:
		if Input.is_action_pressed("W"):
			$Camera2D.position.y -= 20 * $Camera2D.zoom.x
		elif Input.is_action_pressed("A"):
			$Camera2D.position.x -= 20 * $Camera2D.zoom.x
	if Input.is_action_pressed("S"):
		$Camera2D.position.y += 20 * $Camera2D.zoom.x
	elif Input.is_action_pressed("D"):
		$Camera2D.position.x += 20 * $Camera2D.zoom.x
	if $Highlight.visible:
		move_child($Highlight, get_child_count())

func _input(event):
	if event is InputEventMouse:
		var local_coord = to_local(event.position) - Vector2(512, 300)
		var hl:Vector2 = Vector2.ZERO
		hl.x = stepify(local_coord.x * $Camera2D.zoom.x + $Camera2D.position.x - 32, 64) + 32
		hl.y = stepify(local_coord.y * $Camera2D.zoom.x + $Camera2D.position.y - 32, 64) + 32
		var id = (hl.x-32)/64 + int((hl.y-32)/64)*wid
		var mouse_in_map:bool = hl.x > 0 and hl.x < wid * 64 and hl.y > 0 and hl.y < wid * 64
		if mouse_in_map:
			$Highlight.visible = true
			$Highlight.position = hl
			emit_signal("tile_over", id, tiles)
		else:
			if $Highlight.visible:
				emit_signal("tile_out")
				$Highlight.visible = false
		if event is InputEventMouseMotion and dragging:
			$Camera2D.position -= event.relative * $Camera2D.zoom.x
		if event is InputEventMouseButton:
			if Input.is_action_just_pressed("left_click") and $Highlight.visible:
				orig_drag_pos = event.position
				dragging = true
			elif Input.is_action_just_released("left_click"):
				dragging = false
				if mouse_in_map:
					if currently_building and not tiles[id].has("type"):
						var bldg = Sprite.new()
						bldg.texture = load("res://sprite_building/%s.png" % currently_building)
						add_child(bldg)
						bldg.position = hl
						tiles[id].bldg = currently_building
						emit_signal("bldg_built", id, tiles, currently_building)
					else:
						emit_signal("tile_clicked", id, tiles)
	if Input.is_action_just_pressed("scroll_up"):
		$Camera2D.zoom /= 1.2
	if Input.is_action_just_pressed("scroll_down"):
		$Camera2D.zoom *= 1.2 
