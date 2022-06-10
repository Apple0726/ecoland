extends Node


var money
var carbone
var satisfactionpop
var biodiversite
var energie_consomation
var energie_production
const base_conso = 10000
var  cycle = 0





func _process(delta):
	energie_consom()
	
	
func money():
	pass
	
func emmission_carbon():
	pass
func miscontent():
	pass
func energie_consom():
	if cycle < 3600 :
		cycle = cycle +1
	else:
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energie_consomation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	print(energie_consomation)

