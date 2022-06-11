extends Node

var minute = 60
var money = 0
var carbone
var happyness = 7200
var happy_prct = 100
var mean_happy = 0
var moy_happy
var biodiversite
var energie_consomation
var energie_production = 12000
var base_conso = 10000
var cycle = 0





func _process(delta):
	energie_consom()
	satisfaction()
	_money()
	
	
func _money():
	if cycle < minute:
		mean_happy = mean_happy + happy_prct
	else:
		money = money + (10000*mean_happy/minute)
		moy_happy = round(mean_happy/minute)
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
	
func energie_consom():
	if cycle < minute :
		cycle = cycle +1
	else:
		if moy_happy >= 99:
			base_conso = base_conso + 10
		if moy_happy > 80 and mean_happy < 99:
			base_conso = base_conso + 5
		if moy_happy<50 and moy_happy > 10:
			base_conso = base_conso - 5
		if moy_happy <= 10:
			base_conso = base_conso - 10
		moy_happy = 0
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energie_consomation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	

