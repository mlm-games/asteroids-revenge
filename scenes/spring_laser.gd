extends CharacterBody2D

# Enemy properties
var amplitude = 150.0  # Adjust this for the size of the sine wave
var frequency = 2.0  # Adjust this for the frequency of the sine wave
var speed = 200.0  # Adjust this for the enemy's movement speed
var direction = Vector2.UP  # Initial movement direction
var time = 0
@onready var random_offset = randf_range(150,550)

func _physics_process(delta):
	time += delta
	position.x = sin(time*frequency)*amplitude #+ random_offset
	velocity = direction * speed
	#$Sprite2D.rotation = lerp($Sprite2D.rotation, position.normalized().angle(), delta)
	# here, -= gives changes spring movement in left (in angular way)
	if random_offset > 200:
		velocity.y -= sin(time*frequency)*amplitude * 1.5
	else:
		velocity.y += sin(time*frequency)*amplitude * 1.5
		
	move_and_slide()
