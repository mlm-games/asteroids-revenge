extends Control

const SETTINGS_PATH = "user://settings.cfg"

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
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


func _on_sound_button_pressed() -> void:
	GameState.sound_effects = !GameState.sound_effects


func update_labels():
	if GameState.sound_effects:
		$VBoxContainer/Sound.text = "Sound: ON"
	else:
		$VBoxContainer/Sound.text = "Sound: OFF"
	
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
		$VBoxContainer/Sound.text = "Enabled"
	else:
		$VBoxContainer/Sound.text = "Disabled"



func _on_check_button_toggled(toggled_on: bool) -> void:
	GameState.fire_button_is_visible = toggled_on
