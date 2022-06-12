extends Node

signal game_over
signal win

var bldg_info = {
	"wind_turbine":{"cost":55000, "pollution":10000, "power":10000},
	"nuclear_plant":{"cost":260000000, "pollution":400000, "power":1000000},
	"solar_panel":{"cost":100000, "pollution":20000, "power":10},
	"centrale_charbon":{"cost":40000000, "pollution":20000, "power":200000},
	"geothermal_plant":{"cost":40000000, "pollution":20000, "power":200000},
	"hydrolic_central":{"cost":40000000, "pollution":20000, "power":200000},
}
var second = 60
var money = 200000000
var pollution = 0
var happiness = 21600
var happy_percentage = 100
var mean_happy = 0
var moy_happy = 0
var biodiversite = 0
var energy_consommation = 0
var energy_production = 0
var wind_power = 0
var solar_power = 0
var pilotable_power = 0
var intermittent_power = 0
var coeff_prod = 0
var base_conso = 600000
var cycle = 0
var nbr_thermal = 0
var nbr_nuclr = 0
var nb_nonrenewable = 0
var game_time = 0
const max_pollution = 100000000

func _ready():
	set_process(false)



func _process(delta):
	update_consumption()
	update_intermittent_power()
	update_power()
	update_happiness()
	update_money()
	update_pollution()
	if pollution > max_pollution or happy_percentage == 0:
		emit_signal("game_over")
		set_process(false)
	if nb_nonrenewable == 0 and happy_percentage> 80 and energy_consommation==energy_production:
		emit_signal("win")
		set_process(false)
	if game_time >= 300:
		emit_signal("win")
		set_process(false)
	
	
func update_money():
	if cycle < second:
		mean_happy = mean_happy + happy_percentage
	else:
		money = money + (1000*mean_happy/second)
		moy_happy = round(mean_happy/second)
		mean_happy = 0

func update_pollution():
	nb_nonrenewable = nbr_nuclr+nbr_thermal	
	pollution += nbr_thermal*0.5*coeff_prod + nbr_nuclr*0.025*coeff_prod # CO2 rejeté par les centrales thermiques+pollution nucléaire

func update_happiness():
	var coef_happy = 0	
	happy_percentage = happiness*100/21600 
	if energy_consommation > energy_production:
		coef_happy=(((energy_consommation-energy_production)/energy_consommation)+1)*2
		if happy_percentage >= 70:
			happiness -= 3*coef_happy
		if happy_percentage > 10 and happy_percentage<70:
			happiness -= 2*coef_happy
		if happy_percentage <=10:
			happiness -= 1*coef_happy
	else :
		if happiness < 21600:
			if happy_percentage >= 70:
				happiness += 2
		if happy_percentage > 10 and happy_percentage<70:
			happiness += 4
		if happy_percentage <= 10:
			happiness += 6
		

func update_consumption():
	if cycle < second :
		cycle = cycle +1
	else:
		game_time += 1
		if moy_happy >= 99:
			base_conso += 10
		if moy_happy > 80 and mean_happy < 99:
			base_conso += 5
		if moy_happy < 50 and moy_happy > 10:
			base_conso -= 5
		if moy_happy <= 10:
			base_conso -= 10
		moy_happy = 0
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energy_consommation = base_conso + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	
func update_intermittent_power():
	intermittent_power = round(solar_power*(randf()+0.1) + wind_power*(randf()+0.1))
	
func update_power():
	var diff
	energy_production = intermittent_power
	if energy_consommation < energy_production:
		energy_production = energy_consommation
	else:
		diff = energy_consommation - energy_production
		if diff>pilotable_power:
			energy_production += pilotable_power
			coeff_prod = 1
		else:
			coeff_prod = diff/pilotable_power
			energy_production = energy_consommation
	

