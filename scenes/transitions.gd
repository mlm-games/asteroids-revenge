extends CanvasLayer

signal faded_to_black

@onready var transition_player: AnimationPlayer = %TransitionPlayer
@onready var transition_rect : ColorRect = $TransitionRect
@onready var white_rect : ColorRect = $OnScreenEffectsRect
@onready var effects_player: AnimationPlayer = %EffectsPlayer

func _ready():
	transition_rect.visible = false
	white_rect.visible = false


func change_scene_with_transition(scene_path):
	transition("fadeToBlack")
	await faded_to_black
	get_tree().change_scene_to_file(scene_path)

func transition(anim_name):
	match anim_name:
		"fadeToBlack":
			transition_rect.visible = true
			transition_player.play(anim_name)
		"slightFlash":
			white_rect.visible = true
			effects_player.play(anim_name)



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fadeToBlack":
		transition_player.play("fadeToNormal")
		faded_to_black.emit()
	if anim_name == "fadeToNormal":
		transition_rect.hide()
	if anim_name == "slightFlash":
		white_rect.hide()
