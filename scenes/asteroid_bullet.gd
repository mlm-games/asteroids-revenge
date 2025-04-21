extends Area2D

var speed := 500

func _physics_process(delta: float) -> void:
	position.y += speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	# Transition.camera_shake(1.5, 0.25, 0.1)
	if body.is_in_group("enemies"):
		body.queue_free()
		%DeathParticles.emitting = true
		%DeathSound.play()
		%DeathParticles.reparent(get_tree().get_root())
		%DeathSound.reparent(get_tree().get_root())
		queue_free()
	elif body.is_in_group("Boss"):
		body.take_damage(20)
		queue_free()
	
		
