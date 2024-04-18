extends RigidBody2D

var speed = 100.0

var velocity = Vector2(0,randf_range(-speed,-speed*2.5))

func _process(_delta):
	linear_velocity = velocity
