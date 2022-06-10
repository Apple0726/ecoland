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
	play = true

func on_map_tile_over(id:int, tiles:Array):
	if tiles[id].has("type"):
		UI.tooltip.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if tiles[id].type == 0:
			UI.tooltip.text = "Lake"
		elif tiles[id].type == 1:
			UI.tooltip.text = "Forest"
		elif tiles[id].type == 2:
			UI.tooltip.text = "City"
	else:
		UI.tooltip.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_map_tile_out():
	UI.tooltip.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_map_tile_click(id:int, tiles:Array):
	pass
