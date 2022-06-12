extends Node2D
signal fade_menu
var tooltip

func _ready():
	pass


func _on_TextureButton_pressed():
	emit_signal("fade_menu", not $CheckBox.pressed)
	return

func _on_ITS_pressed():
	OS.shell_open("https://info-telecom-strasbourg.fr/")


func _on_ITS_mouse_entered():
	tooltip.show_tooltip("Info Télécom Strasbourg")


func _on_ITS_mouse_exited():
	tooltip.hide_tooltip()
