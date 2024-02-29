extends Node2D

func _ready() -> void:
	GameState.hard_mode = false
	GameState.lives = 3
	if GameState.highscore > 700:
		$HardModeButton.show()
		$HurtLabel.hide()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")




func _on_exit_button_pressed():
	get_tree().quit()


func _on_hard_mode_button_pressed() -> void:
	GameState.hard_mode = true
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
