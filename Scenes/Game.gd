extends Node2D

var play = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var UI = preload("res://Scenes/UI.tscn").instance()
var map = preload("res://Scenes/Map.tscn").instance()
	
func _on_MainMenu_fade_menu():
	remove_child($MainMenu)
	add_child(UI)
	add_child(map)
	map.connect("tile_over", self, "on_map_tile_over")
	map.connect("tile_out", self, "on_map_tile_out")
	map.connect("tile_clicked", self, "on_map_tile_click")
	map.connect("bldg_built", self, "on_bldg_built")
	play = true

func on_bldg_built(id:int, tiles:Array, bldg:String):
	if bldg == "eolienn":
		pass
	elif bldg == "nuclear_plant":
		pass
	elif bldg == "solar_panel":
		pass

func on_map_tile_over(id:int, tiles:Array):
	if UI.on_panel:
		UI.tooltip.visible = false
	elif not UI.on_button and not UI.building.texture:
		if tiles[id].has("bldg"):
			UI.tooltip.visible = true
			UI.tooltip.text = tiles[id].bldg
		elif tiles[id].has("type"):
			UI.tooltip.visible = true
			if tiles[id].type == 0:
				UI.tooltip.text = "Lake"
			elif tiles[id].type == 1:
				UI.tooltip.text = "Forest"
			elif tiles[id].type == 2:
				UI.tooltip.text = "City"
		else:
			UI.tooltip.visible = false

func on_map_tile_out():
	UI.tooltip.visible = false

func on_map_tile_click(id:int, tiles:Array):
	pass
