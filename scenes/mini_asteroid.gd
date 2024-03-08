extends Sprite2D

func _ready() -> void:
	if GameState.hard_mode:
		self.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/Meteors/meteorGrey_big"+str(randi_range(1,4))+".png")
	else:
		self.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/Meteors/meteorBrown_big"+str(randi_range(1,4))+".png")
	
