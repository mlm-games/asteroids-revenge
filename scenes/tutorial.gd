extends Control


func _on_back_button_pressed() -> void:
	%MenuClickSound.play()
	Transition.change_scene_with_transition("res://scenes/main.tscn")
