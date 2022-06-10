extends Control

onready var tooltip = $CanvasLayer/Tooltip

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if tooltip.visible:
			tooltip.rect_position = event.position


func _on_Nuclear_mouse_entered():
	tooltip.visible = true
	tooltip.text = "Nuclear power plant"
	tooltip.rect_min_size = Vector2(100, 30)


func _on_Tooltip_visibility_changed():
	if tooltip.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_mouse_exited():
	tooltip.visible = false
