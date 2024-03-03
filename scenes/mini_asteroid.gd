extends Sprite2D

func _ready() -> void:
	self.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/Meteors/meteorBrown_big"+str(randi_range(1,4))+".png")
