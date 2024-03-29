extends Node

var bldg_info = {
	"wind_turbine":{"cost":8000, "pollution":4000, "power":2000, "construction_time":4},
	"nuclear_plant":{"cost":100000, "pollution":10000, "power":10000, "construction_time":4 },
	"solar_panel":{"cost":8000, "pollution":2000, "power":2000, "construction_time":4},
	"centrale_charbon":{"cost":10000, "pollution":7000, "power":6000,"construction_time":4},
	"geothermal_plant":{"cost":30000, "pollution":5000, "power":6000, "construction_time":4},
	"hydro":{"cost":80000, "pollution":2000, "power":8000, "construction_time":4},
	"city":{"cost":2000, "pollution":1000, "power_consumption":2000, "construction_time":4},
}
var second = 60
var money = 20000
var pollution = 0
var happiness = 10800
var happy_percentage = 100
var mean_happy = 0
var moy_happy = 0
var energy_consommation = 0
var energy_production = 0
var wind_power = 0
var solar_power = 0
var pilotable_power = 0
var intermittent_power = 0
var installed_intermittent_power = 0
var coeff_prod = 0
var coeff_feed = 1
var base_conso = 2500
var conso_city = 0
var cycle = 0
var nbr_thermal = 0
var nbr_nuclr = 0
var nb_nonrenewable = 0
var nbr_city = 0
var nbr_field = 0
var nbr_tree = 0
var game_time = 0
var count_victoire = 0
var score = 0
const point_vicoitre = 720
const max_pollution = 100000

func _ready():
	set_process(false)

func init_vars():
	money = 20000
	pollution = 0
	happiness = 10800
	happy_percentage = 100
	mean_happy = 0
	moy_happy = 0
	energy_consommation = 0
	energy_production = 0
	wind_power = 0
	solar_power = 0
	pilotable_power = 0
	intermittent_power = 0
	installed_intermittent_power = 0
	coeff_prod = 0
	coeff_feed = 1
	base_conso = 2500
	conso_city = 0
	cycle = 0
	nbr_thermal = 0
	nbr_nuclr = 0
	nb_nonrenewable = 0
	nbr_city = 0
	nbr_field = 0
	nbr_tree = 0
	game_time = 0
	count_victoire = 0
	score = 0

func _process(delta):
	update_consumption()
	update_intermittent_power()
	update_power()
	update_happiness()
	update_money()
	update_pollution()
	update_score()
	if pollution > max_pollution or happy_percentage <= 0:
		score = 0
		get_node("/root/Game")._on_game_over()
		#emit_signal("game_over")
	if nb_nonrenewable == 0 and happy_percentage> 90 and energy_consommation<=energy_production:
		count_victoire +=1
		if count_victoire>=point_vicoitre:
			score += (300-game_time)*100 + money/10000 
			get_node("/root/Game")._on_win()
		#emit_signal("win")
	if game_time >= 300:
		score +=  money/ 1000
		get_node("/root/Game")._on_win()
		#emit_signal("win")
	if nb_nonrenewable > 0 or happy_percentage <= 90 or energy_consommation>energy_production:
		count_victoire = 0
	
	
func update_money():
	if cycle < second:
		mean_happy = mean_happy + happy_percentage
	else:
		money +=  (8*mean_happy/second)*nbr_city
		moy_happy = round(mean_happy/second)
		mean_happy = 0

func update_pollution():
	nb_nonrenewable = nbr_nuclr+nbr_thermal
	pollution += nbr_thermal*2.9*coeff_prod + nbr_nuclr*1.8*coeff_prod  # CO2 rejeté par les centrales 
	if pollution>=0:
		pollution += nbr_city*0.07 - nbr_tree*0.02
	if pollution< 0:
		pollution = 0
		
func update_happiness():
	var coef_happy = 0
	var coef_enrj = (energy_consommation - energy_production)/energy_consommation
	coeff_feed = nbr_city/nbr_field
	if coeff_feed<1:
		coeff_feed = 1
	happy_percentage = happiness*100/21600 
	if coef_enrj > 0.3 :
		coef_happy=(((energy_consommation-energy_production)/energy_consommation)+1)*coeff_feed
		if happy_percentage >= 70:
			happiness -= 3*coef_happy
		if happy_percentage > 10 and happy_percentage<70:
			happiness -= 2*coef_happy
		if happy_percentage <=10:
			happiness -= 1*coef_happy
	if  coef_enrj < 0.01:
		if happiness < 21600:
			if happy_percentage >= 70:
				happiness += 2
		if happy_percentage > 10 and happy_percentage<70:
			happiness += 4
		if happy_percentage <= 10:
			happiness += 6
		

func update_consumption():
	conso_city = nbr_city*bldg_info.city.power_consumption
	if cycle < second :
		cycle = cycle +1
	else:
		game_time += 1
		base_conso += 50
#		if moy_happy >= 99:
#			base_conso += 10
#		if moy_happy > 80 and mean_happy < 99:
#			base_conso += 5
#		if moy_happy < 50 and moy_happy > 10:
#			base_conso -= 5
#		if moy_happy <= 10:
#			base_conso -= 10
		moy_happy = 0
		cycle = 0
	var random = RandomNumberGenerator.new()
	random.randomize()
	energy_consommation = base_conso + conso_city + random.randi_range(-100, 100) + round(1000*sin(2*PI*cycle/3600))
	
	
func update_intermittent_power():
	installed_intermittent_power= solar_power + wind_power
	intermittent_power = round(solar_power*(randf()+0.1) + wind_power*(randf()+0.1))
	
func update_power():
	var diff
	energy_production = intermittent_power
	if energy_consommation < energy_production:
		energy_production = energy_consommation + 1
	else:
		diff = energy_consommation - energy_production
		if diff>pilotable_power:
			energy_production += pilotable_power
			coeff_prod = 1
		else:
			coeff_prod = diff/pilotable_power
			energy_production = energy_consommation
func update_score():
	score +=  (max_pollution - pollution)/1000000  + happy_percentage/100000 


func format_num(num:float):
	if num < pow(10, 6):
		var string = str(num)
		var arr = string.split(".")
		if len(arr) == 1:
			arr.append("")
		else:
			arr[1] = "." + arr[1]
		var mod = arr[0].length() % 3
		var res = ""
		for i in range(0, arr[0].length()):
			if i != 0 and i % 3 == mod:
				res += ","
			res += string[i]
		return res + arr[1]
	else:
		var suff:String = ""
		var p:float = log(num) / log(10)
		if is_equal_approx(p, ceil(p)):
			p = ceil(p)
		else:
			p = int(p)
		var div = max(pow(10, stepify(p - 1, 3)), 1)
		if p >= 3 and p < 6:
			suff = "k"
		elif p < 9:
			suff = "M"
		elif p < 12:
			suff = "G"
		elif p < 15:
			suff = "T"
		elif p < 18:
			suff = "P"
		elif p < 21:
			suff = "E"
		elif p < 24:
			suff = "Z"
		elif p < 27:
			suff = "Y"
		return "%.2f%s" % [num / div, suff]
