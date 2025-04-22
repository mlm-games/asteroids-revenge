extends CharacterBody2D

 
@export var speed: float
var follow : bool = false
var initial_rotation : float = 3*PI/2

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	velocity.y = randf_range(-speed,-speed*5)
	var direction : Vector2 = global_position.direction_to(player.global_position)
	var angle : float = direction.angle_to(Vector2.RIGHT)
	if follow:
		if !%LockOnSound.playing:
				%LockOnSound.play()
		if player.force_field:
			velocity.x = direction.x * -speed
		else:
			velocity.x = direction.x * speed
		if GameState.hard_mode:
			rotation = lerp_angle(rotation, angle, delta * 2.0)
			%PlayerDetection.rotation = 0
		else:
			if angle > PI/2:
				rotation = max(deg_to_rad(-120), lerp_angle(rotation,angle,delta/3))
			elif angle > 0:
				rotation = min(-PI/3, lerp_angle(rotation,angle,delta/3))
	else:
		rotation = lerp_angle(rotation, initial_rotation,delta/3)
	
	move_and_slide()

func _on_player_detection_body_entered(_body: PhysicsBody2D) -> void:
	follow = true
	if not player.force_field:
		velocity.y = 500


func _on_player_detection_body_exited(_body: Node2D) -> void:
	follow = false
	if player.force_field:
		follow = true
		%LockOnSound.volume_db = -80
