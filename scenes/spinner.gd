extends RigidBody2D

var speed : float = 100.0

var velocity : Vector2 = Vector2(0,randf_range(-speed,-speed*2.5))

func _process(_delta: float) -> void:
	linear_velocity = velocity
