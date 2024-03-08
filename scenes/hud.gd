extends CanvasLayer

var called:bool = false

func _ready() -> void:
	$"Virtual Joystick".visible = GameState.joystick_is_visible
	$FireButton.visible = GameState.fire_button_is_visible

func _process(_delta):
	if %BulletsBar.value == 5:
		%AnimationPlayer.play("fullBar")
	elif %AnimationPlayer.current_animation == "fullBar":
		%AnimationPlayer.stop()

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
	Transition.transition("slightFlash")
	if score > 0:
		$HighscoreLabel.show()
	elif score < 0:
		$LowestScoreLabel.show()
	$DeathLabel.show()
	await get_tree().create_timer(0.8).timeout
	called = true
	%AnimationPlayer.play("showText")
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_anything_pressed() && called:
		called = false
		Transition.change_scene_with_transition("res://scenes/main.tscn")
		$PressAnyKeyLabel.hide()

