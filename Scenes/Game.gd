
extends Node2D

var play = false
onready var tooltip = $CanvasLayer/Tooltip

func _ready():
	$MainMenu.tooltip = tooltip

var UI = preload("res://Scenes/UI.tscn").instance()
var map = preload("res://Scenes/Map.tscn").instance()
var mouse_pos:Vector2 = Vector2.ZERO

func _on_MainMenu_fade_menu():
	$AnimationPlayer.play("Fade")

func on_bldg_built(id:int, tiles:Array, bldg:String):
	if bldg == "eolienn":
		Scoremanager.carbon += 10000
	elif bldg == "nuclear_plant":
		Scoremanager.carbon += 100000
	elif bldg == "solar_panel":
		Scoremanager.carbon += 1000

		

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
			tooltip.hide_tooltip()

func on_map_tile_out():
	UI.tooltip.visible = false

func on_map_tile_click(id:int, tiles:Array):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if not play:
		remove_child($MainMenu)
		$AnimationPlayer.play_backwards("Fade")
		add_child(UI)
		add_child(map)
		map.connect("tile_over", self, "on_map_tile_over")
		map.connect("tile_out", self, "on_map_tile_out")
		map.connect("tile_clicked", self, "on_map_tile_click")
		map.connect("bldg_built", self, "on_bldg_built")
		play = true
