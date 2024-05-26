extends CanvasLayer

var called:bool = false
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	%"Virtual Joystick".visible = GameState.joystick_is_visible
	%FireButton.visible = GameState.fire_button_is_visible

func _process(_delta):
	%BulletsBar.value = 5 - player.bullets_fired
	if %BulletsBar.value == 5:
		%BulletsBar/AnimationPlayer.play("fullBar")
	elif %BulletsBar/AnimationPlayer.current_animation == "fullBar":
		%BulletsBar/AnimationPlayer.stop()

func update_lives(lives):
	%LivesLabel.text = tr("GAME_CHARACTER_LIVES") + ": " + str(lives)

func update_score(score, highscore, lowestscore) -> void:
	%ScoreLabel.text = str(score)
	if score > 0:
		%HighscoreLabel.text = tr("GAME_OBJECTIVE_HIGH_SCORE") + "
		" + str(highscore)
	elif score < 0:
		%LowestScoreLabel.text = tr("GAME_OBJECTIVE_LOWEST_SCORE") + "
		" + str(lowestscore)

func game_over(score) -> void:
	GameState.save_game()
	Transition.transition("slightFlash")
	if score > 0:
		%HighscoreLabel.show()
	elif score < 0:
		% LowestScoreLabel.show()
	%DeathLabel.show()
	await get_tree().create_timer(0.8).timeout
	called = true
	%PressAnyKeyLabel/AnimationPlayer.play("showText")
	
func _input(event: InputEvent) -> void:
	if event.is_pressed() && called:
		called = false
		Transition.change_scene_with_transition("res://scenes/main.tscn")

