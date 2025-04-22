extends CharacterBody2D

# Enemy properties
var amplitude : float = 150.0  # Adjust this for the size of the sine wave
var frequency : float = 2.0  # Adjust this for the frequency of the sine wave
var speed : float = 200.0  
var direction : Vector2i = Vector2i.UP  # Initial movement direction
var time : float = 0

@onready var random_offset : float = randf_range(150,550)
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

#func _ready() -> void:
#	position.x = random_offset

func _physics_process(delta: float) -> void:
	time += delta
	velocity.x = sin(time*frequency)*amplitude
	velocity.y = direction.y * speed
	
	#Apply additional force based on sine wave offset(with velocity on y - axis) in frenzy
	if GameState.hard_mode:
		# here, without any if-else and multiplying with 0.75 and += gives zig-zag movemnt (in angular way) (depends on speed variable also)
		velocity.y -= abs(sin(time*frequency)*amplitude) * 1.5
		
	move_and_slide()
	
	# Update sprite2D and collisionshape2d rotation based on movement direction
	var angle : float = velocity.angle_to(Vector2i.UP)
	sprite_2d.rotation = -angle
	collision_shape_2d.rotation = -angle
