extends Control

const SETTINGS_PATH = "user://settings.cfg"

func _process(delta: float) -> void:
	update_labels()

func save_settings():
	#Saves the configuartion
	var config = ConfigFile.new()
	config.set_value("sounds", "music", GameState.music)
	config.set_value("sounds", "effects", GameState.sound_effects)
	var _err = config.save(SETTINGS_PATH)


func load_settings():
	#loads the settings
	var config = ConfigFile.new()
	var default_options = {
			"music": true,
			"effects": true,
			}
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		return default_options
	var options = {}
	GameState.music = config.get_value("sounds", "music", default_options.music)
	GameState.sound_effects = config.get_value("sounds", "effects", default_options.effects)
	return options



func _on_music_button_pressed() -> void:
	GameState.music = !GameState.music
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !GameState.music)


func _on_sound_effects_button_pressed() -> void:
	GameState.sound_effects = !GameState.sound_effects
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), !GameState.sound_effects)


func update_labels():
	if GameState.sound_effects:
		$VBoxContainer/SoundEffects.text = "Sound: ON"
	else:
		$VBoxContainer/SoundEffects.text = "Sound: OFF"
	
	if GameState.music:
		$VBoxContainer/Music.text = "Music: ON"
	else:
		$VBoxContainer/Music.text = "Music: OFF"


func _on_back_button_pressed() -> void:
	save_settings()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_joystick_check_box_toggled(toggled_on: bool) -> void:
	GameState.joystick_is_visible = toggled_on
	if toggled_on:
		$VBoxContainer2/JoystickCheckBox.text = "Enabled"
	else:
		$VBoxContainer2/JoystickCheckBox.text = "Disabled"



func _on_check_button_toggled(toggled_on: bool) -> void:
	GameState.fire_button_is_visible = toggled_on
	if toggled_on:
		$VBoxContainer2/CheckButton.text = "Enabled"
	else:
		$VBoxContainer2/CheckButton.text = "Disabled"

#region Text Size code
#func _on_option_button_item_selected(index: int) -> void:
#	GameState.textsize = GameState.TEXT_SIZES[index]
	
	



#func resize_text_controls(size=null):
#	if size == null:
#		size = GameState.load().text_size
#	var alt_theme = null
#	if size == Consts.TextSizes.BIG:
#		alt_theme = load("res://src/ui/theme_big.tres")
#	elif size == Consts.TextSizes.HUGE:
#		alt_theme = load("res://src/ui/theme_really_big.tres")
#	else:
#		# If the theme has never been touched, we don't have to force load from disk.
#		# We could detect that by connecting to Theme.changed.
#		alt_theme = ResourceLoader.load("res://src/ui/theme.tres", "", ResourceLoader.CACHE_MODE_IGNORE)
#
#	var theme = ThemeDB.get_project_theme()
#	theme.merge_with(alt_theme)

#endregion
