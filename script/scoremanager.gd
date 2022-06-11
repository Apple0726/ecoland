extends Node

var minute = 60
var money = 0
var carbone
var happyness = 7200
var happy_prct = 100
var mean_happy = 0
var biodiversite
var energie_consomation
var energie_production = 12000
var base_conso = 10000
var  cycle = 0





func _process(delta):
	energie_consom()
	satisfaction()
	_money()
	
	
func _money():
	if cycle < minute:
		mean_happy = mean_happy + happy_prct
	else:
		money = money + (10000*mean_happy/minute)
		mean_happy = 0
		
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
	if cycle < minute :
		cycle = cycle +1
	else:
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energie_consomation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	

