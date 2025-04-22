extends CharacterBody2D

#HACK: looks in the direction of its movement

var amplitude : float = 150.0 
var frequency : float = 2.0  
var speed : float = 200.0  
var direction : Vector2 = Vector2(1,-1) 
var initial_pos : Vector2
var time : float = 0.0

@onready var random_offset : float = randf_range(150,550)
#@onready var sprite_2d: Sprite2D = %Sprite2D
#@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _physics_process(delta: float) -> void:
	time += delta
	position.x = sin(time*frequency)*amplitude + random_offset 
	velocity.y = direction.y * speed
	
	#$Sprite2D.rotation = lerp($Sprite2D.rotation, position.normalized().angle(), delta)
	# here, -= gives changes spring movement in left (in angular way)
	
	if random_offset > 200:
		velocity.y += sin(time*frequency)*amplitude * 1.5
	else:
		velocity.y += sin(time*frequency)*amplitude * 1.5
	
	#rotation = rotate_toward(rotation, global_position.angle_to(velocity.normalized()), delta)
	move_and_slide()
	
	# Update sprite2D and collisionshape2d rotation based on movement direction
#	var angle = velocity.angle_to(Vector2.UP)
#	sprite_2d.rotation = -angle
#	collision_shape_2d.rotation = -angle
