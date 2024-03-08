extends Control



func _ready() -> void:
	update_labels()


func _on_music_button_pressed() -> void:
	GameState.music = !GameState.music
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !GameState.music)
	update_labels()
	GameState.save_game()

func _on_sound_effects_button_pressed() -> void:
	GameState.sound_effects = !GameState.sound_effects
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), !GameState.sound_effects)
	update_labels()
	GameState.save_game()

func update_labels():
	$VBoxContainer/SoundEffectsButton.text = "Sound: " + ("ON" if GameState.sound_effects else "OFF")
	$VBoxContainer/Music.text = "Music: " + ("ON" if GameState.music else "OFF")
	$VBoxContainer/JoystickButton.text = "Joystick: " + ("Enabled" if GameState.joystick_is_visible else "Disabled")
	$VBoxContainer/FireTouchButton.text = "Fire Button: " + ("Enabled" if GameState.fire_button_is_visible else "Disabled")

func _on_back_button_pressed() -> void:
	GameState.save_game()
	Transition.change_scene_with_transition("res://scenes/main.tscn")


func _on_joystick_button_toggled(toggled_on: bool) -> void:
	GameState.joystick_is_visible = toggled_on
	update_labels()
	GameState.save_game()

func _on_fire_touch_button_toggled(toggled_on: bool) -> void:
	GameState.fire_button_is_visible = toggled_on
	update_labels()
	GameState.save_game()

#region Text Size code
"""
const TEXT_THEMES = [
	preload("res://src/ui/theme.tres"),
	preload("res://src/ui/theme_big.tres"),
	preload("res://src/ui/theme_really_big.tres")
]

func _on_option_button_item_selected(index: int) -> void:
	GameState.textsize = GameState.TEXT_SIZES[index]
	resize_text_controls(index)

func resize_text_controls(index: int) -> void:
	var theme = ThemeDB.get_project_theme()
	theme.merge_with(TEXT_THEMES[index])
"""
#endregion

#region saving/loading settings



#endregion
