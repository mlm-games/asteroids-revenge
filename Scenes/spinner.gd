extends RigidBody2D

var speed = 100.0

var velocity = Vector2(0,randf_range(-speed,-speed*2.5))

func _ready():
	scale = Vector2(2.5,2.5)

func _process(delta):
	%Sprite2D.rotation += delta * 20
	linear_velocity = velocity
