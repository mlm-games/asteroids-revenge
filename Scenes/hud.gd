extends CanvasLayer

var called:bool = false

func _process(_delta):
	
	if called == true:
		forever_input_checker()

func update_lives(lives):
	$LivesLabel.text = "Lives: " + str(lives)

func update_score(score,highscore,lowestscore) -> void:
	$ScoreLabel.text = str(score)
	if score > 0:
		$HighscoreLabel.text = "Highscore
		" + str(highscore)
	elif score < 0:
		$LowestScoreLabel.text = "Lowest score 
		" + str(lowestscore)

func game_over(score) -> void:
	%TransitionScreen.transition("slightFlash")
	if score > 0:
		$HighscoreLabel.show()
	elif score < 0:
		$LowestScoreLabel.show()
	$DeathLabel.show()
	await get_tree().create_timer(0.8).timeout
	called = true
	$AnimationPlayer.play("showText")
	
func forever_input_checker() -> void:
	$PressAnyKeyLabel.show()
	if Input.is_anything_pressed():
		called = false
		%TransitionScreen.transition("fadeToBlack")
		await %TransitionScreen.faded_to_black
		$PressAnyKeyLabel.hide()
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")
