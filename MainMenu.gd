extends Node2D
signal fade_menu


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	emit_signal("fade_menu")
	return
