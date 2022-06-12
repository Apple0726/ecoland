extends Label

var mouse_pos:Vector2 = Vector2.ZERO
var default_font = theme.default_font

func show_tooltip(txt:String):
	var arr2 = txt.split("\n")
	var max_width = 0
	for st in arr2:
		var bb_start:int = st.find("[")
		var bb_end:int = st.find("]")
		while bb_start != -1 and bb_end != -1:
			st = st.replace(st.substr(bb_start, bb_end - bb_start + 1), "")
			bb_start = st.find("[")
			bb_end = st.find("]")
		var width = min(default_font.get_string_size(st).x, 400)
		max_width = max(width, max_width)
	text = txt
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_pos()
	rect_min_size.x = min(max_width, 400)
	rect_size.x = 0
	rect_size.y = 0
	visible = true

func hide_tooltip():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if visible:
			set_pos()

func set_pos():
	rect_position = mouse_pos
	if rect_position.x > 960 - rect_size.x:
		rect_position.x = 960 - rect_size.x
	if rect_position.y > 600 - rect_size.y:
		rect_position.y = 600 - rect_size.y
