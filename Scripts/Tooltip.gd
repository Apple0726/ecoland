extends Label

var mouse_pos:Vector2 = Vector2.ZERO
var default_font = theme.default_font

func show_tooltip(st:String):
	text = st
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	rect_position = mouse_pos
	rect_min_size.x = min(default_font.get_string_size(text).x, 400)
	rect_min_size.y = min(default_font.get_string_size(text).y, 400)
	rect_size.x = 0
	rect_size.y = 0
	yield(get_tree(), "idle_frame")
	visible = true

func hide_tooltip():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if visible:
			rect_position = mouse_pos
			if rect_position.x > 1024 - rect_size.x:
				rect_position.x = 1024 - rect_size.x
			if rect_position.y > 600 - rect_size.y:
				rect_position.y = 600 - rect_size.y
