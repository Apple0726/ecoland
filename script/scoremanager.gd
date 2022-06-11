extends Node
signal bldg_built
var bldg_info = {
	"eolienn":{"cost":55000, "pollution":10000, "power":10000},
	"nuclear_plant":{"cost":260000000, "pollution":400000, "power":1000000},
	"solar_panel":{"cost":100000, "pollution":20000, "power":10},
	"centrale charbon":{"cost":40000000, "pollution":20000, "power":200000},
	"geothermal_plant":{"cost":40000000, "pollution":20000, "power":200000},
	"hydrolic_central":{"cost":40000000, "pollution":20000, "power":200000},
}
var minute = 60
var money = 200000000
var pollution = 0
var happiness = 7200
var happy_prct = 100
var mean_happy = 0
var moy_happy = 0
var biodiversite = 0
var energie_consommation = 0
var energie_production = 0
var wind_power = 0
var solar_power = 0
var pilotable_power = 0
var intermittent_power = 0
var coeff_prod = 0
var base_conso = 600000
var cycle = 0
var nbr_thermal = 0
var nbr_nuclr = 0
var nb_unrenewable = 0
var game_time = 0

func _ready():
	set_process(false)



func _process(delta):
	energie_consom()
	_energie_intermittent()
	_energie_product()
	satisfaction()
	_money()
	emmission_pollution()
	
	
func _money():
	if cycle < minute:
		mean_happy = mean_happy + happy_prct
	else:
		money = money + (10000*mean_happy/minute)
		moy_happy = round(mean_happy/minute)
		mean_happy = 0
func emmission_pollution():
	nb_unrenewable=nbr_nuclr+nbr_thermal	
	pollution += nbr_thermal*0.5 + nbr_nuclr*0.025 # CO2 rejeté par les centrales thermiques+pollution nucléaire

func satisfaction():
	happy_prct = happiness*100/7200 
	if energie_consommation > energie_production:
		happiness = happiness - 10
	else :
		if happiness < 7200:
			happiness = happiness + 1

func energie_consom():
	if cycle < minute :
		cycle = cycle +1
	else:
		game_time += 1
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
	energie_consommation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	
func _energie_intermittent():
	
	intermittent_power= round(solar_power*(randf()+0.1) + wind_power*(randf()+0.1))
	
func _energie_product():
	var diff
	energie_production = intermittent_power
	if energie_consommation < energie_production:
		energie_production = energie_consommation
	else:
		diff = energie_consommation - energie_production
		if diff>pilotable_power:
			energie_production += pilotable_power
		else:
			coeff_prod = diff/pilotable_power
			energie_production = energie_consommation
	

