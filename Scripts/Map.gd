extends Node2D
signal tile_over
signal tile_out
signal tile_clicked
signal bldg_built
signal trees_destroyed
signal bldg_destroyed
var wid = 25

var nbr_city = 0
var currently_building = ""
var current_action = ""
var orig_drag_pos:Vector2
var dragging = false
var mouse_pos:Vector2
var tiles = []
var tuto:bool
var sprites = {}

enum TileType {
	LAKE,
	FOREST,
	CITY,
}

func rand_int(low:int, high:int):
	return randi() % (high - low + 1) + low

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
				sprites[str(t_id)] = tree
				tree.position = Vector2(i, j) * 64 + Vector2(32, 32)
				tile = {"type":TileType.FOREST}
			if city_level > 0.5 and tree_level < 0.5 and level < 0.5:
				var city = preload("res://Scenes/City.tscn").instance()
				add_child(city)
				city.position = Vector2(i, j) * 64 + Vector2(32, 32)
				tile = {"type":TileType.CITY}
				nbr_city += 1
			tiles.append(tile)
	generate_zones("sun_beams")
	randomize()
	generate_zones("wind")
	$Camera2D.position = Vector2.ONE * wid * 64 / 2.0

func generate_zones(st:String):
	var diff:int = 0
	var rand:float = randf()
	var thiccness:int = ceil(rand_int(1, 3) * wid / 50.0)
	var pulsation:float = rand_range(0.4, 1)
	var amplitude:float = 0.85
	var num_beams:int = 2
	var tile_from:int = -1
	var tile_to:int = -1
	for i in num_beams:
		var intensity = rand_range(1.8, 2.5)
		if tile_from == -1:
			tile_from = rand_int(0, wid)
			tile_to = rand_int(0, wid)
		if rand < 0.5:#Vertical
			for j in wid:
				var x_pos:int = lerp(tile_from, tile_to, j / float(wid)) + diff + thiccness * amplitude * sin(j / float(wid) * 4 * pulsation * PI)
				for k in range(x_pos - int(thiccness / 2) + diff, x_pos + int(ceil(thiccness / 2.0)) + diff):
					if k < 0 or k > wid - 1:
						continue
					tiles[k + j * wid][st] = intensity
					if st == "sun_beams":
						var sun_beams = preload("res://Scenes/SunBeams.tscn").instance()
						add_child(sun_beams)
						sun_beams.position = Vector2(k, j) * 64 + Vector2(32, 32)
					elif st == "wind":
						var wind = preload("res://Scenes/Wind.tscn").instance()
						add_child(wind)
						wind.position = Vector2(k, j) * 64 + Vector2(32, 32)
		else:#Horizontal
			for j in wid:
				var y_pos:int = lerp(tile_from, tile_to, j / float(wid)) + diff + thiccness * amplitude * sin(j / float(wid) * 4 * pulsation * PI)
				for k in range(y_pos - int(thiccness / 2) + diff, y_pos + int(ceil(thiccness / 2.0)) + diff):
					if k < 0 or k > wid - 1:
						continue
					tiles[j + k * wid][st] = intensity
					if st == "sun_beams":
						var sun_beams = preload("res://Scenes/SunBeams.tscn").instance()
						add_child(sun_beams)
						sun_beams.position = Vector2(j, k) * 64 + Vector2(32, 32)
					elif st == "wind":
						var wind = preload("res://Scenes/Wind.tscn").instance()
						add_child(wind)
						wind.position = Vector2(j, k) * 64 + Vector2(32, 32)
		if wid / 3 == 1:
			diff = thiccness + 1
		else:
			diff = rand_int(thiccness + 1, wid / 3) * sign(rand_range(-1, 1))
	
func _process(delta):
	if tuto:
		return
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
	if tuto:
		return
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
					if currently_building and not tiles[id].has("type") and Scoremanager.money >= Scoremanager.bldg_info[currently_building].cost:
						var bldg = Sprite.new()
						bldg.texture = load("res://sprite_building/%s.png" % currently_building)
						add_child(bldg)
						bldg.position = hl
						sprites[str(id)] = bldg
						tiles[id].bldg = currently_building
						emit_signal("bldg_built", id, tiles, currently_building)
					elif current_action:
						if current_action == "chop_trees" and tiles[id].has("type") and tiles[id].type == TileType.FOREST:
							tiles[id].erase("type")
							sprites[str(id)].queue_free()
							emit_signal("trees_destroyed")
						elif current_action == "destroy_bldg" and tiles[id].has("bldg"):
							emit_signal("bldg_destroyed", id, tiles, tiles[id].bldg)
							tiles[id].erase("bldg")
							sprites[str(id)].queue_free()
							
							
					else:
						emit_signal("tile_clicked", id, tiles)

	if Input.is_action_just_pressed("scroll_up"):
		$Camera2D.zoom /= 1.2
	if Input.is_action_just_pressed("scroll_down"):
		$Camera2D.zoom *= 1.2 
