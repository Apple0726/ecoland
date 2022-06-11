extends Control

var current_text:int = 0
var moved = false

var texts = [
	"Welcome to [color=green][wave amp=20 freq=7]Ecoland[/wave][/color]!\nThe year is 2022, and you are the manager of this piece of land, where the population partly relies on fossil fuels for energy.",
	"Your job is to make the population rely less on fossil fuels and more on renewable sources of energy.",
	"Most of us know by now that fossil fuels are one of the big dangers to biodiversity and pollution.",
	"And it is a challenge to smooth the transition from fossil fuels to cleaner alternatives, because we need to keep the population happy!",
	"I am confident that in 15 years, Ecoland will fully make that transition. [wave amp=20 freq=7]I believe in you![/wave]",
	"Press one of the buttons at the right to start building. See you in 15 years!"
]
func _ready():
	$Panel/Label.bbcode_text = texts[0]
	set_process(false)
	$AnimationPlayer.play("Begin")

func _process(delta):
	$Panel/Label.visible_characters += delta * 60.0
	$Arrow.visible = $Panel/Label.visible_characters >= len($Panel/Label.text)
	if not moved and current_text == 4 and $Panel/Label.visible_characters >= 75:
		moved = true
		$AnimationPlayer3.play("MovePerson")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Begin":
		set_process(true)
	elif anim_name == "End":
		queue_free()

func _on_Button_pressed():
	if not $AnimationPlayer.is_playing():
		if $Panel/Label.visible_characters < len($Panel/Label.text):
			$Panel/Label.visible_characters = len($Panel/Label.text)
		else:
			current_text += 1
			if current_text == 5:
				$BuildButtons.visible = true
			elif current_text == 6:
				$AnimationPlayer.play("End")
				set_process(false)
				return
			$Panel/Label.bbcode_text = texts[current_text]
			$Panel/Label.visible_characters = 0
