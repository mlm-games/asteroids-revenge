extends Control

func _ready() -> void:
	if GameState.first_time_opened:
		%FirstTimeAnimPlayer.play("blink",-1,0.75)
		GameState.first_time_opened = false
	GameState.hard_mode = false
	GameState.lives = 3
	if GameState.boss_defeated:
		%HardModeButton.show()
		%HintLabel.hide()
	GameState.save_game()
	%StartButton.grab_focus()


func _on_start_button_pressed():
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/world.tscn")


func _on_exit_button_pressed():
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


func _on_touch_screen_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/settings.tscn")
