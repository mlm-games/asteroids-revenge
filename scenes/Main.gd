extends Node2D

func _ready() -> void:
	GameState.hard_mode = false
	GameState.lives = 3
	if GameState.highscore > 700:
		$HardModeButton.show()
		$HintLabel.hide()


func _on_start_button_pressed():
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_button_pressed():
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().quit()


func _on_hard_mode_button_pressed() -> void:
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	GameState.hard_mode = true
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_help_button_pressed() -> void:
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_touch_screen_button_pressed() -> void:
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
