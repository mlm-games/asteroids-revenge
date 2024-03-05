extends Node

var highscore :int= 0
var lowestscore :int= 0
var lives:int = 3
var hard_mode := false
var sound_effects := true
var music := true
var textsize:= 1
const TEXT_SIZES: Array = ["SMALL","BIG","VERY BIG"]
var fire_button_is_visible := true
var joystick_is_visible := true


#region Saving and loading
func _ready() -> void:
	save_game()
	load_game()

const SavePath = "user://savegame.save"

func save_game():
	var save_file = FileAccess.open(SavePath ,FileAccess.WRITE)
	var data: Dictionary = {
		"highscore": highscore,
		"lowestscore": lowestscore,
		"textsize": textsize
	}
	
	var jstr := JSON.stringify(data)
	save_file.store_line(jstr)

func load_game():
	var save_file = FileAccess.open(SavePath ,FileAccess.READ)
	if FileAccess.file_exists(SavePath):                               #you can also put '== true:' near end
		if not save_file.eof_reached():
			var current_line = JSON.parse_string(save_file.get_line())
			if current_line:
				highscore = current_line["highscore"]
				lowestscore = current_line["lowestscore"]
				textsize = current_line["textsize"]


#endregion
