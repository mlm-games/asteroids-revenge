extends Node

const SAVE_PATH = "user://savegame.save"

var highscore :int= 0
var lowestscore :int= 0
var lives:int = 3
var hard_mode := false
var sound_effects := true
var music := true
#var textsize:= 1
#const TEXT_SIZES: Array = ["SMALL","BIG","VERY BIG"]
var fire_button_is_visible := false
var joystick_is_visible := false
var boss_defeated : bool = false
var locale : String = "en"
var frenzy_high_score : int = 0
var frenzy_lowest_score:int = 0
var first_time_opened: bool
var player_alt_touch_controls: bool = false

var boss_rush_mode := false
var boss_rush_level := 0
var boss_health_multiplier := 1.0
var max_boss_rush_level := 0

#region Saving and loading
func _ready() -> void:
	if !FileAccess.file_exists(SAVE_PATH):
		first_time_opened = true
		locale = OS.get_locale_language()
		if OS.get_name() == "Android" or OS.has_feature("web_android") or OS.has_feature("web_ios"):
			joystick_is_visible = true
			fire_button_is_visible = true
	
	load_game()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !GameState.music)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), !GameState.sound_effects)
	TranslationServer.set_locale(locale)
	print("System language: ", locale + ", OS: ", OS.get_name())


func start_boss_rush() -> void:
	boss_rush_mode = true
	boss_rush_level = 0
	boss_health_multiplier = 1.0

func next_boss_level() -> void:
	boss_rush_level += 1
	boss_health_multiplier = 1.0 + (boss_rush_level * 0.2) #20% per level

func save_game() -> void:
	var save_file : FileAccess = FileAccess.open(SAVE_PATH ,FileAccess.WRITE)
	var data: Dictionary = {
		"highscore": highscore,
		"lowestscore": lowestscore,
		"music": music,
		"sound_effects": sound_effects,
		"fire_button_is_visible": fire_button_is_visible,
		"joystick_is_visible": joystick_is_visible,
		"boss_defeated": boss_defeated,
		"locale": locale,
		"frenzy_high_score": frenzy_high_score,
		"frenzy_lowest_score": frenzy_lowest_score,
		"player_alt_touch_controls": player_alt_touch_controls,
		"max_boss_rush_level": max_boss_rush_level
	}
	
	var jstr := JSON.stringify(data)
	save_file.store_line(jstr)

func load_game() -> void:
	var save_file : FileAccess = FileAccess.open(SAVE_PATH ,FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):                               #you can also put '== true:' near end
		if not save_file.eof_reached():
			var current_line : Dictionary = JSON.parse_string(save_file.get_line())
			if current_line:
				highscore = current_line["highscore"]
				lowestscore = current_line["lowestscore"]
				music = current_line["music"]
				sound_effects = current_line["sound_effects"]
				fire_button_is_visible = current_line["fire_button_is_visible"]
				joystick_is_visible = current_line["joystick_is_visible"]
				boss_defeated = current_line["boss_defeated"]
				locale = current_line["locale"]
				frenzy_high_score = current_line["frenzy_high_score"]
				frenzy_lowest_score = current_line["frenzy_lowest_score"]
				player_alt_touch_controls = current_line["player_alt_touch_controls"]
				if "max_boss_rush_level" in current_line:
					boss_rush_level = current_line["max_boss_rush_level"]

#endregion
