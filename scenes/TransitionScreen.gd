extends CanvasLayer

signal faded_to_black

@onready var animation_player = $AnimationPlayer
@onready var black_rect = $BlackRect
@onready var white_rect = $WhiteRect

func _ready():
	black_rect.visible = false
	white_rect.visible = false


func change_scene_with_transition(scene_path):
	transition("fadeToBlack")
	await faded_to_black
	get_tree().change_scene_to_file(scene_path)

func transition(anim_name):
	match anim_name:
		"fadeToBlack":
			black_rect.visible = true
		"slightFlash":
			white_rect.visible = true
	animation_player.play(anim_name)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fadeToBlack":
		animation_player.play("fadeToNormal")
		faded_to_black.emit()
	if anim_name == "fadeToNormal":
		black_rect.hide()
	if anim_name == "slightFlash":
		white_rect.hide()
