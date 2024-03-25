extends Node

const SETTINGS_PATH = "user://settings.cfg"
const SAVE_PATH = "user://savegame.save"

var highscore :int= 0
var lowestscore :int= 0
var lives:int = 3
var hard_mode := false
var sound_effects := true
var music := true
#var textsize:= 1
#const TEXT_SIZES: Array = ["SMALL","BIG","VERY BIG"]
var fire_button_is_visible := true
var joystick_is_visible := true
var boss_defeated = false
var locale : String = "en"


#region Saving and loading
func _ready() -> void:
	load_game()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !GameState.music)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), !GameState.sound_effects)



func save_game():
	var save_file = FileAccess.open(SAVE_PATH ,FileAccess.WRITE)
	var data: Dictionary = {
		"highscore": highscore,
		"lowestscore": lowestscore,
		"music": music,
		"sound_effects": sound_effects,
		"fire_button_is_visible": fire_button_is_visible,
		"joystick_is_visible": joystick_is_visible,
		"boss_defeated": boss_defeated,
		"locale": locale,
	}
	
	var jstr := JSON.stringify(data)
	save_file.store_line(jstr)

func load_game():
	var save_file = FileAccess.open(SAVE_PATH ,FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):                               #you can also put '== true:' near end
		if not save_file.eof_reached():
			var current_line = JSON.parse_string(save_file.get_line())
			if current_line:
				highscore = current_line["highscore"]
				lowestscore = current_line["lowestscore"]
				music = current_line["music"]
				sound_effects = current_line["sound_effects"]
				fire_button_is_visible = current_line["fire_button_is_visible"]
				joystick_is_visible = current_line["joystick_is_visible"]
				boss_defeated = current_line["boss_defeated"]
				locale = current_line["locale"]
#endregion
