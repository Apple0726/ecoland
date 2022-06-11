extends Node



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save_game():
	var save_file = File.new()
	save_file.open("user://Save%s.sav" % [c_sv], File.WRITE)
	var save_info:Dictionary = {
		"curr_world":curr_world,
		"player_position":Vector2.ZERO,
	}
	save_file.store_var(save_info)
	save_file.close()
	
func load_game(slot:int):
	var save_file = File.new()
	save_file.open("user://Save%s.sav" % [slot], File.READ)
	var save_info:Dictionary = save_file.get_var()
	save_file.close()
	for key in save_info:
		if key in self:
			self[key] = save_info[key]
