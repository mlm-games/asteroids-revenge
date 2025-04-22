extends CanvasLayer

signal faded_to_black

@onready var transition_player: AnimationPlayer = %TransitionPlayer
@onready var transition_rect : ColorRect = $TransitionRect
@onready var white_rect : ColorRect = $OnScreenEffectsRect
@onready var effects_player: AnimationPlayer = %EffectsPlayer

func _ready() -> void:
	transition_rect.visible = false
	white_rect.visible = false


func change_scene_with_transition(scene_path: StringName) -> void:
	transition("fadeToBlack")
	await faded_to_black
	get_tree().change_scene_to_file(scene_path)

func transition(anim_name: StringName) -> void:
	match anim_name:
		"fadeToBlack":
			transition_rect.visible = true
			transition_player.play(anim_name)
		"slightFlash":
			white_rect.visible = true
			effects_player.play(anim_name)



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeToBlack":
		transition_player.play("fadeToNormal")
		faded_to_black.emit()
	if anim_name == "fadeToNormal":
		transition_rect.hide()
	if anim_name == "slightFlash":
		white_rect.hide()


func camera_shake(intensity: float = 1.5, duration: float = 1.5, decay: float = 3.0, camera: Camera2D = get_viewport().get_camera_2d()) -> void:
	# Stop any existing shake tweens
	if camera.has_meta("shake_tween") and camera.get_meta("shake_tween").is_valid():
			camera.get_meta("shake_tween").kill()
	
	var tween : Tween = create_tween()
	camera.set_meta("shake_tween", tween)
	
	var original_position := camera.position
	var original_rotation := camera.rotation
	
	# This will be called by tween_method to update the camera shake
	var shake_function := func(progress: float) -> void:
		var remaining := 1.0 - progress
		var current_intensity := intensity * pow(remaining, decay)
		
		if current_intensity > 0.01:
			var cam_offset := Vector2(
				intensity * 5.0 * current_intensity * randf_range(-1, 1),
				intensity * 5.0 * current_intensity * randf_range(-1, 1)
			)
			var cam_rotation := 0.1 * intensity * current_intensity * randf_range(-1, 1)
			
			camera.position = original_position + cam_offset
			camera.rotation = original_rotation + cam_rotation
		else:
			if camera: # incase scene is changed
				camera.position = original_position
				camera.rotation = original_rotation
	
	#call our shake function over the duration
	tween.tween_method(shake_function, 0.0, 1.0, duration)
	
	# Reset camera when done
	tween.tween_callback(func() -> void:
		camera.position = original_position
		camera.rotation = original_rotation
	)
