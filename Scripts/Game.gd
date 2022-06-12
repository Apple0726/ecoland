extends Node2D

onready var tooltip = $CanvasLayer/Tooltip
var play = false
var UI 
var map
var mouse_pos:Vector2 = Vector2.ZERO
var play_tuto:bool

func _ready():
	$MainMenu.tooltip = tooltip

func _on_MainMenu_fade_menu(_play_tuto:bool):
	play_tuto = _play_tuto
	$AnimationPlayer.play("Fade")

func on_bldg_built(id:int, tiles:Array, bldg:String):
	if bldg == "wind_turbine":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
		if tiles[id].has("wind"):
			ScoreManager.wind_power += ScoreManager.bldg_info[bldg].power * tiles[id].wind
		else:
			ScoreManager.wind_power += ScoreManager.bldg_info[bldg].power
	elif bldg == "nuclear_plant":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
		ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power
		ScoreManager.nb_nonrenewable += 1
	elif bldg == "solar_panel":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
		if tiles[id].has("sun_beams"):
			ScoreManager.solar_power += ScoreManager.bldg_info[bldg].power * tiles[id].sun_beams
		else:
			ScoreManager.solar_power += ScoreManager.bldg_info[bldg].power
	elif bldg == "centrale_charbon":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
		ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power
		ScoreManager.nbr_thermal += 1
	elif bldg == "geothermal_plant":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
		ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power
	#elif bldg == "hydrolic_central":
	#	ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution
	#	ScoreManager.money -= ScoreManager.bldg_info[bldg].cost
	#	ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power
	
		

func trees_destroyed():
	ScoreManager.nbr_tree -=1
	ScoreManager.money -= 1000

func field_destroyed():
	ScoreManager.nbr_field -=1
	ScoreManager.money -=  1000


func bldg_destroyed(id:int, tiles:Array, bldg:String):
	if bldg == "wind_turbine":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
		if tiles[id].has("wind"):
			ScoreManager.wind_power -= ScoreManager.bldg_info[bldg].power * tiles[id].wind
		else:
			ScoreManager.wind_power -= ScoreManager.bldg_info[bldg].power
	elif bldg == "nuclear_plant":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
		ScoreManager.pilotable_power -= ScoreManager.bldg_info[bldg].power
		ScoreManager.nb_nonrenewable -= 1
	elif bldg == "solar_panel":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
		if tiles[id].has("sun_beams"):
			ScoreManager.solar_power -= ScoreManager.bldg_info[bldg].power * tiles[id].sun_beams
		else:
			ScoreManager.solar_power -= ScoreManager.bldg_info[bldg].power
	elif bldg == "centrale_charbon":
		ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
		ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
		ScoreManager.pilotable_power -= ScoreManager.bldg_info[bldg].power
		ScoreManager.nbr_thermal -= 1
	#elif bldg == "geothermal_plant":
	#	ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
	#	ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
	#	ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power
	#elif bldg == "hydrolic_central":
	#	ScoreManager.pollution += ScoreManager.bldg_info[bldg].pollution/3
	#	ScoreManager.money -= ScoreManager.bldg_info[bldg].cost/4
	#	ScoreManager.pilotable_power += ScoreManager.bldg_info[bldg].power

func on_map_tile_over(id:int, tiles:Array):
	if UI.on_panel:
		tooltip.hide_tooltip()
	elif not UI.on_button and not UI.building.texture:
		if tiles[id].has("bldg"):
			tooltip.show_tooltip(tiles[id].bldg)
		elif tiles[id].has("type"):
			var txt = ""
			if tiles[id].type == 0:
				txt = "Lake"
			elif tiles[id].type == 1:
				txt = "Forest"
			elif tiles[id].type == 2:
				txt = "City"
			elif tiles[id].type == 3:
				txt = "Farmland"
			tooltip.show_tooltip(txt)
		else:
			var txt = ""
			if tiles[id].has("sun_beams"):
				txt = "Sunny area (solar panel production multiplied by %.2f)" % tiles[id].sun_beams
			if tiles[id].has("wind"):
				if txt != "":
					txt += "\n"
				txt += "Windy area (wind turbine production multiplied by %.2f)" % tiles[id].wind
			if txt == "":
				tooltip.hide_tooltip()
			else:
				tooltip.show_tooltip(txt)

func on_map_tile_out():
	tooltip.hide_tooltip()

func on_map_tile_click(id:int, tiles:Array, pos:Vector2):
	if UI.on_panel or UI.on_button:
		return
	var currently_building = map.currently_building
	var current_action = map.current_action
	if currently_building and not tiles[id].has("type") and not tiles[id].has("bldg") and ScoreManager.money >= ScoreManager.bldg_info[currently_building].cost:
		var bldg = Sprite.new()
		bldg.texture = load("res://Graphics/sprite_building/%s.png" % currently_building)
		add_child(bldg)
		bldg.position = pos
		map.sprites[str(id)] = bldg
		tiles[id].bldg = currently_building
		map.emit_signal("bldg_built", id, tiles, currently_building)
	elif current_action:
		if current_action == "chop_trees" and tiles[id].has("type"):
			if tiles[id].type == map.TileType.FOREST:
				map.emit_signal("trees_destroyed")
			elif tiles[id].type == map.TileType.FIELD:
				map.emit_signal("field_destroyed")
			map.sprites[str(id)].queue_free()
			tiles[id].erase("type")
		elif current_action == "destroy_bldg" and tiles[id].has("bldg"):
			map.emit_signal("bldg_destroyed", id, tiles, tiles[id].bldg)
			tiles[id].erase("bldg")
			map.sprites[str(id)].queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if not play:
		$MainMenu.queue_free()
		UI = preload("res://Scenes/UI.tscn").instance()
		map = preload("res://Scenes/Map.tscn").instance()
		$AnimationPlayer.play_backwards("Fade")
		add_child(UI)
		add_child(map)
		map.tuto = play_tuto
		map.connect("tile_over", self, "on_map_tile_over")
		map.connect("tile_out", self, "on_map_tile_out")
		map.connect("tile_clicked", self, "on_map_tile_click")
		map.connect("bldg_built", self, "on_bldg_built")
		map.connect("trees_destroyed", self, "trees_destroyed")
		map.connect("field_destroyed", self, "field_destroyed")
		map.connect("bldg_destroyed", self, "bldg_destroyed")
		play = true
		if play_tuto:
			yield(get_tree().create_timer(0.5), "timeout")
			var tuto = preload("res://Scenes/Tutorial.tscn").instance()
			tuto.type = tuto.TUTORIAL
			UI.get_node("CanvasLayer").add_child(tuto)
			tuto.connect("tree_exiting", self, "on_tuto_done")
		else:
			ScoreManager.set_process(true)

func on_tuto_done():
	map.tuto = false
	#Start doing resource calculations
	ScoreManager.set_process(true)

func _on_game_over():
	tooltip.hide_tooltip()
	map.tuto = true
	ScoreManager.set_process(false)
	var tuto = preload("res://Scenes/Tutorial.tscn").instance()
	tuto.type = tuto.GAME_OVER
	UI.get_node("CanvasLayer").add_child(tuto)
	tuto.connect("tree_exited", self, "back_to_menu")

func _on_win():
	tooltip.hide_tooltip()
	map.tuto = true
	ScoreManager.set_process(false)
	var tuto = preload("res://Scenes/Tutorial.tscn").instance()
	tuto.type = tuto.VICTORY
	UI.get_node("CanvasLayer").add_child(tuto)
	tuto.connect("tree_exited", self, "back_to_menu")

func back_to_menu():
	map.queue_free()
	UI.queue_free()
	play = false
	var menu = preload("res://Scenes/MainMenu.tscn").instance()
	call_deferred("add_child", menu)
	menu.tooltip = tooltip
	menu.name = "MainMenu"
	menu.connect("fade_menu", self, "_on_MainMenu_fade_menu")
