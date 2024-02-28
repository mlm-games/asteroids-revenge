extends Node

var highscore :int= 0
var lowestscore :int= 0



#region Saving and loading


const SavePath = "user://savegame.save"

func savegame():
	var save_file = FileAccess.open(SavePath ,FileAccess.WRITE)
	var data: Dictionary = {
		"highscore": highscore,
		"lowestscore": lowestscore
	}
	
	var jstr = JSON.stringify(data)
	save_file.store_line(jstr)

func loadgame():
	var save_file = FileAccess.open(SavePath ,FileAccess.READ)
	if FileAccess.file_exists(SavePath):                               #you can also put '== true:' near end
		if not save_file.eof_reached():
			var current_line = JSON.parse_string(save_file.get_line())
			if current_line:
				highscore = current_line["highscore"]
				lowestscore = current_line["lowestscore"]


#endregion
