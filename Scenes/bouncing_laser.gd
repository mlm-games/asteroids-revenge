extends CharacterBody2D

@export var speed : float

func _ready() -> void:
	rotation = PI/4



func _physics_process(delta: float) -> void:
	velocity = Vector2(0,-speed).rotated(rotation)
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if velocity.x > 0:
		rotation += 3*PI/2
	else:
		rotation -= 3*PI/2
