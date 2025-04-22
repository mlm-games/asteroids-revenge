extends CharacterBody2D

# Enemy properties
var speed : float = 150


func _physics_process(_delta: float) -> void:
	velocity = speed * Vector2.UP
	move_and_slide()
	


func _on_teleport_timer_timeout() -> void:
	%AnimationPlayer.play("fade-out")
	await %AnimationPlayer.animation_finished
	if !GameState.hard_mode:
		if global_position.x < get_viewport_rect().size.x / 2:
			global_position.x += (get_viewport_rect().size.x/2 - global_position.x) * 2
		else:
			global_position.x -= (global_position.x - get_viewport_rect().size.x / 2) * 2
	else:
		if global_position.x < get_viewport_rect().size.x / 2:
			global_position.x += get_viewport_rect().size.x / 2
		else:
			global_position.x -= get_viewport_rect().size.x / 2

	%AnimationPlayer.play("fade-in")
