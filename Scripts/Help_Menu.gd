extends Node2D
signal fade_help_menu



func _on_TextureButton_pressed():
	emit_signal("fade_help_menu")
