extends Control

var on_button = false
var on_panel = false
onready var tooltip = get_parent().tooltip

onready var building = $CanvasLayer/Building

func _ready():
	pass # Replace with function body.

func _process(delta):
	$CanvasLayer/MoneyVBox/Label.text = format_num(ScoreManager.money)
	$CanvasLayer/PollutionVBox/Label.text = "%s / %s" % [format_num(round(ScoreManager.pollution)), format_num(ScoreManager.max_pollution)]
	if (ScoreManager.pollution - ScoreManager.max_pollution)/ScoreManager.max_pollution < 0.1:
		$CanvasLayer/PollutionVBox/Label["custom_colors/font_color"] = Color.red
	$CanvasLayer/EnergyVBox/Label.text = "%s / %s \n %s \n %s" % [format_num(round(ScoreManager.energy_production)),format_num(round(ScoreManager.energy_consommation)),format_num(round(ScoreManager.pilotable_power)),format_num(round(ScoreManager.installed_intermittent_power))]
	if ScoreManager.energy_production >= ScoreManager.energy_consommation:
		$CanvasLayer/EnergyVBox/Label["custom_colors/font_color"] = Color.green
	else:
		$CanvasLayer/EnergyVBox/Label["custom_colors/font_color"] = Color.red
	$CanvasLayer/HappinessVBox/Label.text = "%s%%" % str(round(ScoreManager.happy_percentage))
	if ScoreManager.happy_percentage > 70:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.green
	elif ScoreManager.happy_percentage > 40:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.yellow
	else:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.red

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
		get_parent().map.current_action = ""

func _on_mouse_exited():
	on_button = false
	tooltip.hide_tooltip()

func _on_CoalPlant_pressed():
	set_texture($CanvasLayer/Buildings/VBox/CoalPlant.texture_normal, "centrale_charbon")

func _on_Nuclear_pressed():
	set_texture($CanvasLayer/Buildings/VBox/Nuclear.texture_normal, "nuclear_plant")

func _on_WindTurbine_pressed():
	set_texture($CanvasLayer/Buildings/VBox/WindTurbine.texture_normal, "wind_turbine")

func _on_SolarPanel_pressed():
	set_texture($CanvasLayer/Buildings/VBox/SolarPanel.texture_normal, "solar_panel")

func set_texture(t, st:String, bldg = true):
	if building.visible and get_parent().map.currently_building == st:
		building.visible = false
		building.texture = null
		get_parent().map.currently_building = ""
	elif building.visible and get_parent().map.current_action == st:
		building.visible = false
		building.texture = null
		get_parent().map.current_action = ""
	else:
		building.visible = true
		building.texture = t
		if bldg:
			get_parent().map.currently_building = st
			get_parent().map.current_action = ""
		else:
			get_parent().map.currently_building = ""
			get_parent().map.current_action = st
		building.rect_position = mouse_pos - Vector2(32, 32)

func _on_Nuclear_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Nuclear power plant\nCost: %s money\n+%s controllable power\n+%s pollution" % [format_num(ScoreManager.bldg_info.nuclear_plant.cost), format_num(ScoreManager.bldg_info.nuclear_plant.power), format_num(ScoreManager.bldg_info.nuclear_plant.pollution)])


func _on_SolarPanel_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Solar panels\nCost: %s money\n+%s controllable power\n+%s pollution" % [format_num(ScoreManager.bldg_info.solar_panel.cost), format_num(ScoreManager.bldg_info.solar_panel.power), format_num(ScoreManager.bldg_info.solar_panel.pollution)])


func _on_WindTurbine_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Wind turbines\nCost: %s money\n+%s controllable power\n+%s pollution" % [format_num(ScoreManager.bldg_info.wind_turbine.cost), format_num(ScoreManager.bldg_info.wind_turbine.power), format_num(ScoreManager.bldg_info.wind_turbine.pollution)])

func _on_CoalPlant_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Coal plant\nCost: %s money\n+%s controllable power\n+%s pollution" % [format_num(ScoreManager.bldg_info["centrale_charbon"].cost), format_num(ScoreManager.bldg_info["centrale_charbon"].power), format_num(ScoreManager.bldg_info["centrale_charbon"].pollution)])

func _on_Buildings_mouse_entered():
	on_panel = true


func _on_Buildings_mouse_exited():
	on_panel = false


func _on_Money_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Money")

func _on_Pollution_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Pollution")

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



func _on_ChopTrees_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Chop trees.\nMakes more land for your buildings, but creates pollution.")


func _on_ChopTrees_pressed():
	set_texture($CanvasLayer/Actions/VBox/ChopTrees.texture_normal, "chop_trees", false)


func _on_DestroyBldg_pressed():
	set_texture($CanvasLayer/Actions/VBox/DestroyBldg.texture_normal, "destroy_bldg", false)


func _on_DestroyBldg_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Destroy a building.\nCosts money and creates pollution.")


func _on_Actions_mouse_entered():
	on_panel = true


func _on_Actions_mouse_exited():
	on_panel = false

func _on_GameOver_pressed():
	tooltip.hide_tooltip()
	get_parent()._on_game_over()


func _on_Victory_pressed():
	tooltip.hide_tooltip()
	get_parent()._on_win()


func _on_Timer_timeout():
	if ScoreManager.happy_percentage > 70:
		$CanvasLayer/HappinessVBox/Happiness.texture = preload("res://Graphics/Happiness.png")
	elif ScoreManager.happy_percentage > 40:
		$CanvasLayer/HappinessVBox/Happiness.texture = preload("res://Graphics/neutral.png")
	else:
		$CanvasLayer/HappinessVBox/Happiness.texture = preload("res://Graphics/unhappiness.png")
