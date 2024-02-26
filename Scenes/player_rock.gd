extends CharacterBody2D

signal game_over

const SPEED = 400.0
static var direction = Vector2(0,0)

@export var rockBullet:PackedScene 

func _physics_process(delta):
	if visible:
		%Sprite2D.rotation+=delta
		direction = Input.get_vector("left", "right","up","down")
		velocity = direction * SPEED
		velocity.y /= 2
		velocity.x *= 1.2
		if move_and_slide():
			game_over.emit()
		
	#	if Input.is_action_pressed("fire"):
	#		shoot()

#func shoot():
#	add_child(rockBullet.instantiate())

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		direction = snapped(self.global_position.direction_to(event.position),Vector2(1,1))





func _on_visible_on_screen_notifier_2d_screen_exited():
	game_over.emit()
