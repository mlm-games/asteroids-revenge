extends Node

const SAVE_PATH = "user://savegame.bin"

@onready var highscore :int= 0
@onready var lowestscore :int= 0



#region Saving and loading




func savegame():
	var file = FileAccess.open(SAVE_PATH ,FileAccess.WRITE)
	var data: Dictionary = {
		"highscore": highscore,
		"lowestscore": lowestscore
	}
	
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadgame():
	var file = FileAccess.open(SAVE_PATH ,FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):                               #you can also put '== true:' near end
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				highscore = current_line["highscore"]
				lowestscore = current_line["lowestscore"]


#endregion
