extends CanvasLayer

signal game_restarted

const MAX_BULLETS = 5

var called: bool = false
@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	%"Virtual Joystick".visible = GameState.joystick_is_visible
	%FireButton.visible = GameState.fire_button_is_visible
	%ScoreLabel.visible = !GameState.boss_rush_mode
	
	if GameState.player_alt_touch_controls:
		%LeftTouchScreenButton.show()
		%RightTouchScreenButton.show()
		%LeftTouchScreenButton2.show()
		%RightTouchScreenButton2.show()
		%"Virtual Joystick".process_mode = Node.PROCESS_MODE_DISABLED
		%"Virtual Joystick".hide()
		%FireButton.scale = Vector2(4,4)
		%FireButton.global_position.x = ProjectSettings.get_setting("display/window/size/viewport_width")/2  - (%FireButton.texture_normal.get_size().x * %FireButton.scale.x)/2
	
	# Connect to player signals (for opening scene without player i.e debugging)
	if player:
		player.bullet_fired.connect(_on_player_bullet_fired)
		player.bullets_reset.connect(_on_player_bullets_reset)


func update_lives(lives: int) -> void:
	%LivesLabel.text = tr("GAME_CHARACTER_LIVES") + ": " + str(lives)


func update_score(score: int, highscore: int, lowestscore: int) -> void:
	%ScoreLabel.text = str(score)
	if score > 0:
		%HighscoreLabel.text = tr("GAME_OBJECTIVE_HIGH_SCORE") + "\n" + str(highscore)
	elif score < 0:
		%LowestScoreLabel.text = tr("GAME_OBJECTIVE_LOWEST_SCORE") + "\n" + str(lowestscore)


func game_over(score: int) -> void:
	GameState.save_game()
	Transition.transition("slightFlash")
	if score > 0:
		%HighscoreLabel.show()
	elif score < 0:
		%LowestScoreLabel.show()
	%DeathLabel.show()
	await get_tree().create_timer(0.8).timeout
	called = true
	%PressAnyKeyLabel/AnimationPlayer.play("showText")


func _input(event: InputEvent) -> void:
	if event.is_pressed() && called:
		called = false
		game_restarted.emit()
		Transition.change_scene_with_transition("res://scenes/main.tscn")


func update_bullets_bar(bullets_fired: int) -> void:
	%BulletsBar.value = MAX_BULLETS - bullets_fired 
	if %BulletsBar.value == MAX_BULLETS:
		%BulletsBar/AnimationPlayer.play("fullBar")
	elif %BulletsBar/AnimationPlayer.current_animation == "fullBar":
		%BulletsBar/AnimationPlayer.stop()


func _on_player_bullet_fired() -> void:
	update_bullets_bar(player.bullets_fired)


func _on_player_bullets_reset() -> void:
	update_bullets_bar(0)
