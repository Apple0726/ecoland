extends Node2D
signal fade_menu
var tooltip

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	emit_signal("fade_menu")
	return


func _on_Sprite_mouse_entered():
	tooltip.show_tooltip("Info Télécom Strasbourg")


func _on_Sprite_mouse_exited():
	tooltip.hide_tooltip()


func _on_Sprite_pressed():
	OS.shell_open("https://info-telecom-strasbourg.fr/")
