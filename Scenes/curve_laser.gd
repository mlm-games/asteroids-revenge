extends CharacterBody2D
#TODO: sprite2D and collisionshape2d rotation based on its current direction of movement

# Enemy properties
var amplitude = 150.0  # Adjust this for the size of the sine wave
var frequency = 2.0  # Adjust this for the frequency of the sine wave
var speed = 200.0  # Adjust this for the enemy's movement speed
var direction = Vector2.UP  # Initial movement direction
var time = 0
@onready var random_offset = randf_range(150,550)

func _physics_process(delta):
	time += delta
	position.x = sin(time*frequency)*amplitude + random_offset
	velocity = direction * speed
	
	#Apply additional force based on sine wave offset(with velocity on y - axis) in frenzy
	if GameState.hard_mode:
		# here, without any if-else and multiplying with 0.75 and += gives zig-zag movemnt (in angular way) (depends on speed variable also)
		velocity.y -= abs(sin(time*frequency)*amplitude) * 1.5
		
	move_and_slide()
