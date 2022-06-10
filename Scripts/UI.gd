extends Control

onready var tooltip = $CanvasLayer/Tooltip

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if tooltip.visible:
			tooltip.rect_position = event.position
