extends Control

@onready var tween := get_tree().create_tween()

func _ready() -> void:
	%StartButton.pressed.connect(_on_start_button_pressed)
	%HardModeButton.pressed.connect(_on_hard_mode_button_pressed)
	%BossRushModeButton.pressed.connect(_on_boss_rush_mode_button_pressed)
	%ExitButton.pressed.connect(_on_exit_button_pressed)
	%HelpButton.pressed.connect(_on_help_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)


	if GameState.first_time_opened:
		%FirstTimeAnimPlayer.play("blink",-1,0.75)
		GameState.first_time_opened = false
	GameState.hard_mode = false
	if GameState.boss_defeated:
		%BossRushModeButton.show()
		%HardModeButton.show()
		%HintLabel.hide()
	
	
	GameState.save_game()
	%StartButton.grab_focus()
	
	#HACK: Remove the title as a child of container, and then add anim
	%AnimSound.play()
	tween.parallel().tween_property(%GameName, "position", %GameName.position, 1.25
	).from(%GameName.position + Vector2(0, 200)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(%MarginContainer, "position", Vector2.ZERO, 1.2
	).from(%MarginContainer.position - Vector2(0, 100)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay(0.25)

	


func _on_start_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/world.tscn")


func _on_exit_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().quit()


func _on_hard_mode_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/world.tscn")
	GameState.hard_mode = true


func _on_help_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/tutorial.tscn")


func _on_settings_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/settings.tscn")


func _on_boss_rush_mode_button_pressed() -> void:
	%MenuClickSound.play()
	GameState.start_boss_rush()
	Transition.change_scene_with_transition("res://scenes/world.tscn")
