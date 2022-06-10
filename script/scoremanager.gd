extends Node


var money = 0
var carbone
var happyness = 7200
var happy_prct = 100
var biodiversite
var energie_consomation
var energie_production = 12000
const base_conso = 10000
var  cycle = 0





func _process(delta):
	energie_consom()
	satisfaction()
	_money()
	
	
func _money():
	money = 10 + money
	
func emmission_carbon():
	pass
func satisfaction():
	happy_prct = happyness*100/7200 
	if energie_consomation > energie_production:
		happyness = happyness - 1
	else :
		if happyness < 7200:
			happyness = happyness + 1
	print(happy_prct)
func energie_consom():
	if cycle < 3600 :
		cycle = cycle +1
	else:
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energie_consomation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	

