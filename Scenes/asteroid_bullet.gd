extends Area2D

var speed := 500

func _physics_process(delta: float) -> void:
	position.y += speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if !body.has_signal("hit"):
		body.queue_free()
		queue_free()
