extends Control

enum {TUTORIAL, VICTORY, GAME_OVER}
var type:int
var current_text:int = 0
var moved = false

var texts = [
	"Welcome to [color=green][wave amp=20 freq=7]Ecoland[/wave][/color]!\nThe year is 2022, and you are the manager of this piece of land, where the population partly relies on fossil fuels for energy.",
	"Your job is to make the population rely less on fossil fuels and more on renewable sources of energy.",
	"Most of us know by now that fossil fuels are one of the big dangers to biodiversity and pollution.",
	"And it is a challenge to smooth the transition from fossil fuels to cleaner alternatives, because we need to keep the population happy!",
	"I am confident that in 5 years, [color=green]Ecoland[/color] will fully make that transition. [wave amp=20 freq=7]I believe in you![/wave]",
	"Press one of the buttons at the right to start building.",
	"Be careful, constructing buildings produce pollution. You will want to limit that to keep the residents happy.",
	"See you in 5 years then!",
]
var text_victory = [
	"Wow! [wave amp=20 freq=7]You really did it![/wave]",
	"The residents of [color=green]Ecoland[/color], now using 100% renewable energy, seem to be very happy about how you handled the situation.",
	"All the wildlife in the nearby forests and lakes seem to be thankful for your actions.",
	"We are now one step closer to becoming a truly sustainable society!",
]
var text_game_over = [
	"Well, I gotta say... This isn't looking good at all.",
	"Residents are suffocating in the thick smog of air in the cities, with little to no trees to absorb the excess carbon.",
	"Animals and marine life are slowly going extinct as their habitat progressively becomes uninhabitable.",
	"It pains me to say this, but... I guess it is true that all civilizations eventually die out.",
	"It was nice knowing you. Let's at least enjoy our final moments on Earth before we all suffocate to death, one by one.",
]
func _ready():
	set_process(false)
	if type == TUTORIAL:
		$AnimationPlayer.play("Begin")
		$Panel/Label.bbcode_text = texts[0]
	elif type == VICTORY:
		$AnimationPlayer4.play("FadeBG")
		$BGWin.visible = true
		$Score.visible = true
		$TextureRect.texture = preload("res://Graphics/fille tuto happy.png")
		$Panel/Label.bbcode_text = text_victory[0]
	elif type == GAME_OVER:
		$BGLose.visible = true
		$AnimationPlayer4.play("FadeBG")
		$TextureRect.texture = preload("res://Graphics/fille tuto unhappy.png")
		$Panel/Label.bbcode_text = text_game_over[0]

func _process(delta):
	$Panel/Label.visible_characters += delta * 60.0
	$Panel/Arrow.visible = $Panel/Label.visible_characters >= len($Panel/Label.text)
	if not moved:#Move the presenter up and down at various points in dialogue
		if type == TUTORIAL and current_text == 4 and $Panel/Label.visible_characters >= 75:
			moved = true
			$AnimationPlayer3.play("MovePerson")
			$TextureRect.texture = preload("res://Graphics/fille tuto happy.png")
		elif type == VICTORY and current_text == 0 and $Panel/Label.visible_characters >= 2:
			moved = true
			$AnimationPlayer3.play("MovePerson")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Begin":
		set_process(true)
	elif anim_name == "EndTuto":
			queue_free()
	elif anim_name == "End":
		$Score/AnimationPlayer.play("FadeScore")

func _on_Button_pressed():
	if not $AnimationPlayer.is_playing():
		if $Panel/Label.visible_characters < len($Panel/Label.text):
			$Panel/Label.visible_characters = len($Panel/Label.text)
		else:
			current_text += 1
			if type == TUTORIAL:
				if current_text == 5:
					$BuildButtons.visible = true
				elif current_text == 8:
					$AnimationPlayer.play("EndTuto")
					set_process(false)
					return
				$Panel/Label.bbcode_text = texts[current_text]
				$TextureRect.texture = preload("res://Graphics/fille tuto.png")
			elif type == VICTORY:
				if current_text == 4:
					$AnimationPlayer.play("End")
					set_process(false)
					return
				$Panel/Label.bbcode_text = text_victory[current_text]
			elif type == GAME_OVER:
				if current_text == 3:
					$TextureRect.texture = preload("res://Graphics/fille tuto sad.png")
				elif current_text == 5:
					$AnimationPlayer.play("End")
					set_process(false)
					return
				$Panel/Label.bbcode_text = text_game_over[current_text]
			$Panel/Label.visible_characters = 0


func _on_AnimationPlayer4_animation_finished(anim_name):
	$AnimationPlayer.play("Begin")


func _on_PlayAgain_pressed():
	queue_free()
