extends Control

var on_button = false
var on_panel = false
onready var tooltip = get_parent().tooltip

onready var building = $CanvasLayer/Building

func _ready():
	pass # Replace with function body.

func _process(delta):
	$CanvasLayer/MoneyVBox/Label.text = format_num(Scoremanager.money)
	$CanvasLayer/PollutionVBox/Label.text = format_num(Scoremanager.pollution)
	$CanvasLayer/EnergyVBox/Label.text = "%s / %s" % [format_num(Scoremanager.energie_production), format_num(Scoremanager.energie_consommation)]
	$CanvasLayer/HappinessVBox/Label.text = str(Scoremanager.happy_prct)

var mouse_pos:Vector2 = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if building.visible:
			building.rect_position = mouse_pos - Vector2(32, 32)
	if Input.is_action_just_released("esc"):
		building.visible = false
		building.texture = null
		get_parent().map.currently_building = ""

func _on_mouse_exited():
	on_button = false
	tooltip.hide_tooltip()

func _on_Nuclear_pressed():
	set_texture($CanvasLayer/Buildings/VBox/Nuclear.texture_normal, "nuclear_plant")

func _on_WindTurbine_pressed():
	set_texture($CanvasLayer/Buildings/VBox/WindTurbine.texture_normal, "eolienn")

func _on_SolarPanel_pressed():
	set_texture($CanvasLayer/Buildings/VBox/SolarPanel.texture_normal, "solar_panel")

func set_texture(t, st:String):
	if building.visible and get_parent().map.currently_building == st:
		building.visible = false
		building.texture = null
		get_parent().map.currently_building = ""
	else:
		building.visible = true
		building.texture = t
		get_parent().map.currently_building = st
		building.rect_position = mouse_pos - Vector2(32, 32)

func _on_Nuclear_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Nuclear power plant")


func _on_SolarPanel_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Solar panels")


func _on_WindTurbine_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Wind turbines")


func _on_Buildings_mouse_entered():
	on_panel = true


func _on_Buildings_mouse_exited():
	on_panel = false


func _on_Money_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Money")

func _on_pollution_mouse_entered():
	on_button = true
	tooltip.show_tooltip("pollution")

func _on_Energy_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Energy production / consumption")


func _on_Happiness_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Population happiness")

func format_num(num:float):
	if num < pow(10, 6):
		var string = str(num)
		var arr = string.split(".")
		if len(arr) == 1:
			arr.append("")
		else:
			arr[1] = "." + arr[1]
		var mod = arr[0].length() % 3
		var res = ""
		for i in range(0, arr[0].length()):
			if i != 0 and i % 3 == mod:
				res += ","
			res += string[i]
		return res + arr[1]
	else:
		var suff:String = ""
		var p:float = log(num) / log(10)
		if is_equal_approx(p, ceil(p)):
			p = ceil(p)
		else:
			p = int(p)
		var div = max(pow(10, stepify(p - 1, 3)), 1)
		if p >= 3 and p < 6:
			suff = "k"
		elif p < 9:
			suff = "M"
		elif p < 12:
			suff = "G"
		elif p < 15:
			suff = "T"
		elif p < 18:
			suff = "P"
		elif p < 21:
			suff = "E"
		elif p < 24:
			suff = "Z"
		elif p < 27:
			suff = "Y"
		return "%.2f%s" % [num / div, suff]

