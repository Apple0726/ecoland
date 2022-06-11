extends Control

var on_button = false
var on_panel = false
onready var tooltip = $CanvasLayer/Tooltip
onready var building = $CanvasLayer/Building

func _ready():
	pass # Replace with function body.

func _process(delta):
	$CanvasLayer/VBox/Money/Label.text = str(Scoremanager.money)
	$CanvasLayer/VBox/Energy/Label.text = "%s / %s" % [str(Scoremanager.energie_production), str(Scoremanager.energie_consommation)]
	$CanvasLayer/VBox/Happiness/Label.text = str(Scoremanager.happy_prct)

var mouse_pos:Vector2 = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if tooltip.visible:
			tooltip.rect_position = mouse_pos
			if tooltip.rect_position.x > 1024 - tooltip.rect_size.x:
				tooltip.rect_position.x = 1024 - tooltip.rect_size.x
			if tooltip.rect_position.y > 600 - tooltip.rect_size.y:
				tooltip.rect_position.y = 600 - tooltip.rect_size.y
		if building.visible:
			building.rect_position = mouse_pos - Vector2(32, 32)
	if Input.is_action_just_released("esc"):
		building.visible = false
		building.texture = null
		get_parent().map.currently_building = ""


func _on_Nuclear_mouse_entered():
	show_tooltip("Nuclear power plant")

func show_tooltip(st):
	on_button = true
	tooltip.visible = true
	tooltip.text = st

func _on_Tooltip_visibility_changed():
	if tooltip.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_mouse_exited():
	on_button = false
	tooltip.visible = false

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




func _on_SolarPanel_mouse_entered():
	show_tooltip("Solar panels")


func _on_WindTurbine_mouse_entered():
	show_tooltip("Wind turbines")


func _on_Buildings_mouse_entered():
	on_panel = true


func _on_Buildings_mouse_exited():
	on_panel = false


func _on_Money_mouse_entered():
	show_tooltip("Money")


func _on_Energy_mouse_entered():
	show_tooltip("Energy production / consumption")


func _on_Happiness_mouse_entered():
	show_tooltip("Population happiness")
