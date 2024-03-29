
extends Control

var on_button = false
var on_panel = false
onready var tooltip = get_parent().tooltip
onready var building = $CanvasLayer/Building


func _process(delta):
	var years_left:float = 15 - ScoreManager.game_time / 60.0 * 3
	$CanvasLayer/Progress/Label.text = "%.1f years left!" % (years_left)
	$CanvasLayer/Progress/Bar.rect_size.x = clamp(range_lerp(ScoreManager.game_time, 0.0, 300.0, 0.0, 1.0), 0, 1) * 104
	$CanvasLayer/MoneyVBox/Label.text = ScoreManager.format_num(round(ScoreManager.money))
	$CanvasLayer/PollutionVBox/Label.text = "%s / %s" % [ScoreManager.format_num(round(ScoreManager.pollution)), ScoreManager.format_num(ScoreManager.max_pollution)]
	if (ScoreManager.max_pollution - ScoreManager.pollution)/ScoreManager.max_pollution < 0.1:
		$CanvasLayer/PollutionVBox/Label["custom_colors/font_color"] = Color.red
	$CanvasLayer/HappinessVBox/Label.text = "%s%%" % str(round(ScoreManager.happy_percentage))
	if ScoreManager.happy_percentage > 70:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.green
	elif ScoreManager.happy_percentage > 30:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.yellow
	else:
		$CanvasLayer/HappinessVBox/Label["custom_colors/font_color"] = Color.red

var mouse_pos:Vector2 = Vector2.ZERO
var mouse_in_debug = false

func _on_Help_menu_fade_help_menu():
	$CanvasLayer/Help_menu.hide()
	if $CanvasLayer/Help_button.text == "Press to close":
		$CanvasLayer/Help_button.text = "Help"

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if building.visible:
			building.rect_position = mouse_pos - Vector2(32, 32)
		if mouse_in_debug and not Geometry.is_point_in_polygon(mouse_pos, $CanvasLayer/MouseOut.polygon):
			$CanvasLayer/Debug/AnimationPlayer.play_backwards("MoveDebug")
			mouse_in_debug = false
		if not mouse_in_debug and Geometry.is_point_in_polygon(mouse_pos, $CanvasLayer/MouseIn.polygon):
			$CanvasLayer/Debug/AnimationPlayer.play("MoveDebug")
			mouse_in_debug = true
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

func _on_Geothermal_pressed():
	set_texture($CanvasLayer/Buildings/VBox/Geothermal.texture_normal, "geothermal_plant")

func _on_City_pressed():
	set_texture($CanvasLayer/Buildings/VBox/City.texture_normal, "city")

func _on_Hydro_pressed():
	set_texture($CanvasLayer/Buildings/VBox/Hydro.texture_normal, "hydro")

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
	tooltip.show_tooltip("Nuclear power plant\nCost: € %s\n+%s controllable power\n+%s PP + 174 PP/s" % [ScoreManager.format_num(ScoreManager.bldg_info.nuclear_plant.cost), ScoreManager.format_num(ScoreManager.bldg_info.nuclear_plant.power), ScoreManager.format_num(ScoreManager.bldg_info.nuclear_plant.pollution)])


func _on_SolarPanel_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Solar panels\nProduces continuous power that fluctuates with time.\nCost: € %s\n+%s controllable power\n+%s PP" % [ScoreManager.format_num(ScoreManager.bldg_info.solar_panel.cost), ScoreManager.format_num(ScoreManager.bldg_info.solar_panel.power), ScoreManager.format_num(ScoreManager.bldg_info.solar_panel.pollution)])


func _on_WindTurbine_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Wind turbines\nProduces continuous power that fluctuates with time.\nCost: € %s\n+%s controllable power\n+%s PP" % [ScoreManager.format_num(ScoreManager.bldg_info.wind_turbine.cost), ScoreManager.format_num(ScoreManager.bldg_info.wind_turbine.power), ScoreManager.format_num(ScoreManager.bldg_info.wind_turbine.pollution)])

func _on_CoalPlant_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Coal plant\nProduces cheap, dirty but controllable power that adapts to demand.\nCost: € %s\n+%s controllable power\n+%s PP + 108 PP/s" % [ScoreManager.format_num(ScoreManager.bldg_info["centrale_charbon"].cost), ScoreManager.format_num(ScoreManager.bldg_info["centrale_charbon"].power), ScoreManager.format_num(ScoreManager.bldg_info["centrale_charbon"].pollution)])

func _on_Geothermal_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Geothermal plant\nAn expensive, cleaner alternative for controllable power.\nCost: € %s\n+%s controllable power\n+%s PP" % [ScoreManager.format_num(ScoreManager.bldg_info["geothermal_plant"].cost), ScoreManager.format_num(ScoreManager.bldg_info["geothermal_plant"].power), ScoreManager.format_num(ScoreManager.bldg_info["geothermal_plant"].pollution)])

func _on_Hydro_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Tidal turbines\nProduces clean controllable power. Must be built on water.\nCost: € %s\n+%s controllable power\n+%s PP" % [ScoreManager.format_num(ScoreManager.bldg_info["hydro"].cost), ScoreManager.format_num(ScoreManager.bldg_info["hydro"].power), ScoreManager.format_num(ScoreManager.bldg_info["hydro"].pollution)])


func _on_City_mouse_entered():
	on_button = true
	tooltip.show_tooltip("City\nConstruct buildings where residents live their lives.\nCannot be destroyed once placed.\nCost: € %s\n+%s power consumption of population\n+%s PP" % [ScoreManager.format_num(ScoreManager.bldg_info["city"].cost), ScoreManager.format_num(ScoreManager.bldg_info["city"].power_consumption), ScoreManager.format_num(ScoreManager.bldg_info["city"].pollution)])


func _on_Buildings_mouse_entered():
	on_panel = true


func _on_Buildings_mouse_exited():
	on_panel = false


func _on_Money_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Money\nIncome is affected by number of cities and population happiness.")

func _on_Pollution_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Pollution\nOnce pollution exceeds %s, it's game over!" % ScoreManager.format_num(ScoreManager.max_pollution))

func _on_Energy_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Power production / power consumption of population\nControllable power / continuous power\nPower production is equal to controllable power + continuous power")


func _on_Happiness_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Population happiness")



func _on_ChopTrees_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Destroy a zone (forest, farmland) to make land for your buildings.\nCost: € 1,000\nCreates pollution.")


func _on_ChopTrees_pressed():
	set_texture($CanvasLayer/Actions/VBox/ChopTrees.texture_normal, "chop_trees", false)


func _on_DestroyBldg_pressed():
	set_texture($CanvasLayer/Actions/VBox/DestroyBldg.texture_normal, "destroy_bldg", false)


func _on_DestroyBldg_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Destroy a building.\nCosts money and creates pollution.")

func _on_PlantTrees_pressed():
	set_texture($CanvasLayer/Actions/VBox/PlantTrees.texture_normal, "plant_trees", false)


func _on_PlantTrees_mouse_entered():
	on_button = true
	tooltip.show_tooltip("Plant trees!\nCost: € 10,000\nTrees absorb pollution.")


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
	elif ScoreManager.happy_percentage > 30:
		$CanvasLayer/HappinessVBox/Happiness.texture = preload("res://Graphics/Neutral.png")
	else:
		$CanvasLayer/HappinessVBox/Happiness.texture = preload("res://Graphics/Unhappiness.png")
	$CanvasLayer/EnergyVBox/Label.text = "%s / %s \n%s / %s" % [ScoreManager.format_num(round(ScoreManager.energy_production)),ScoreManager.format_num(round(ScoreManager.energy_consommation)),ScoreManager.format_num(round(ScoreManager.pilotable_power)),ScoreManager.format_num(round(ScoreManager.installed_intermittent_power))]
	if ScoreManager.energy_production >= ScoreManager.energy_consommation:
		$CanvasLayer/EnergyVBox/Label["custom_colors/font_color"] = Color.green
	else:
		$CanvasLayer/EnergyVBox/Label["custom_colors/font_color"] = Color.red



func _on_PauseSimu_pressed():
	if ScoreManager.is_processing():
		ScoreManager.set_process(false)
		$CanvasLayer/PauseSimu.text = "Resume simulation"
	else:
		ScoreManager.set_process(true)
		$CanvasLayer/PauseSimu.text = "Pause simulation"



func _on_Help_button_pressed():
	if ScoreManager.is_processing() and !$CanvasLayer/Help_menu.is_visible_in_tree():
		$CanvasLayer/Help_menu.show()
		ScoreManager.set_process(false)
		$CanvasLayer/Help_button.text = "Press to close"
	else:
		$CanvasLayer/Help_menu.hide()
		ScoreManager.set_process(true)
		$CanvasLayer/Help_button.text = "Help"

