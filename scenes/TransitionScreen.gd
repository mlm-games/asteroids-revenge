extends CanvasLayer

signal faded_to_black

@onready var transition_player: AnimationPlayer = $TransitionRect/TransitionPlayer
@onready var transition_rect : ColorRect = $TransitionRect
@onready var white_rect : ColorRect = $OnScreenEffectsRect
@onready var effects_player: AnimationPlayer = $OnScreenEffectsRect/EffectsPlayer

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



#func _create_fade_scene(texture: CompressedTexture2D) -> Node:
	#var fade_rect = ColorRect.new()
	#fade_rect.set_script(load("res://addons/transitions/FadeScene.gd"))
	#fade_rect.anchors_preset = Control.PRESET_FULL_RECT
	#
	#var material = CanvasItemMaterial.new()
	#material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	#material.set_shader(load("res://addons/transitions/Circle2d.gdshader"))
	#material.set_shader_parameter("dissolve_texture", texture)
	#fade_rect.material = material
	#
	#return fade_rect



