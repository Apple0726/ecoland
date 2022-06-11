
extends Node2D

var play = false
var game_over = false
var win = false
const max_pollution = 1000000
onready var tooltip = $CanvasLayer/Tooltip

func _ready():
	$MainMenu.tooltip = tooltip

func _process(delta):
	win_condition()

var UI = preload("res://Scenes/UI.tscn").instance()
var map = preload("res://Scenes/Map.tscn").instance()
var mouse_pos:Vector2 = Vector2.ZERO
var play_tuto:bool

func _on_MainMenu_fade_menu(_play_tuto:bool):
	play_tuto = _play_tuto
	$AnimationPlayer.play("Fade")

func on_bldg_built(id:int, tiles:Array, bldg:String):
	if bldg == "eolienn":
		Scoremanager.pollution += Scoremanager.bldg_info[bldg].pollution
		Scoremanager.money -= Scoremanager.bldg_info[bldg].cost
		if tiles[id].has("wind"):
			Scoremanager.wind_power += Scoremanager.bldg_info[bldg].power * tiles[id].wind
		else:
			Scoremanager.wind_power += Scoremanager.bldg_info[bldg].power
	elif bldg == "nuclear_plant":
		Scoremanager.pollution += Scoremanager.bldg_info[bldg].pollution
		Scoremanager.money -= Scoremanager.bldg_info[bldg].cost
		Scoremanager.pilotable_power += Scoremanager.bldg_info[bldg].power
		Scoremanager.nb_unrenewable += 1
	elif bldg == "solar_panel":
		Scoremanager.pollution += Scoremanager.bldg_info[bldg].pollution
		Scoremanager.money -= Scoremanager.bldg_info[bldg].cost
		if tiles[id].has("sun_beams"):
			Scoremanager.solar_power += Scoremanager.bldg_info[bldg].power * tiles[id].sun_beams
		else:
			Scoremanager.solar_power += Scoremanager.bldg_info[bldg].power
	#elif bldg == "geothermal_plant":
	#	Scoremanager.pollution += 100000
	#	Scoremanager.money -= 10000
	#	Scoremanager.pilotable_power += 100
	#elif bldg == "hydrolic_central":
	#	Scoremanager.pollution += 100000
	#	Scoremanager.money -= 10000
	#	Scoremanager.pilotable_power += 100
	elif bldg == "thermal_plant":
		Scoremanager.pollution += 100000
		Scoremanager.money -= 10000
		Scoremanager.pilotable_power += 100
		Scoremanager.nb_unrenewable += 1

func trees_destroyed():
	pass
	
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

func on_map_tile_click(id:int, tiles:Array):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if not play:
		remove_child($MainMenu)
		$AnimationPlayer.play_backwards("Fade")
		add_child(UI)
		add_child(map)
		map.tuto = play_tuto
		map.connect("tile_over", self, "on_map_tile_over")
		map.connect("tile_out", self, "on_map_tile_out")
		map.connect("tile_clicked", self, "on_map_tile_click")
		map.connect("bldg_built", self, "on_bldg_built")
		map.connect("trees_destroyed", self, "trees_destroyed")
		play = true
		if play_tuto:
			yield(get_tree().create_timer(0.5), "timeout")
			var tuto = preload("res://Scenes/Tutorial.tscn").instance()
			UI.get_node("CanvasLayer").add_child(tuto)
			tuto.connect("tree_exiting", self, "on_tuto_done")
		else:
			Scoremanager.set_process(true)

func on_tuto_done():
	map.tuto = false
	

func win_condition():
	if  Scoremanager.pollution>max_pollution:
		game_over = true
	if Scoremanager.happy_prct == 0:
		game_over = false
	if Scoremanager.nb_unrenewable == 0 and Scoremanager.happy_prct> 80 and Scoremanager.energie_consommation==Scoremanager.energie_production:
		win= true
	if Scoremanager.game_time >= 15:
		win = true

