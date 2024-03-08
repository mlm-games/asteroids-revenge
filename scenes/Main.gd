extends Node2D

func _ready() -> void:
	GameState.hard_mode = false
	GameState.lives = 3
	if GameState.boss_defeated:
		$HardModeButton.show()
		$HintLabel.hide()


func _on_start_button_pressed():
	Transition.change_scene_with_transition("res://scenes/world.tscn")


func _on_exit_button_pressed():
	Transition.transition("fadeToBlack")
	await Transition.faded_to_black
	get_tree().quit()


func _on_hard_mode_button_pressed() -> void:
	Transition.change_scene_with_transition("res://scenes/world.tscn")
	GameState.hard_mode = true


func _on_help_button_pressed() -> void:
	Transition.change_scene_with_transition("res://scenes/tutorial.tscn")


func _on_touch_screen_button_pressed() -> void:
	Transition.change_scene_with_transition("res://scenes/settings.tscn")
