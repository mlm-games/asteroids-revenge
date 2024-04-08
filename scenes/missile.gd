extends CharacterBody2D

 
#@export var health:int = 15


@export var speed: float
var follow := false
var player: Node2D
var initial_rotation = 3*PI/2

func _ready():
	player = get_node("/root/World/PlayerRock")
	%SmokeTrail.play("default")

func _process(delta):
	velocity = Vector2(0,randf_range(-speed,-speed*5))
	var direction = global_position.direction_to(player.global_position)
	var angle = 	direction.angle_to(Vector2.RIGHT)
	if follow:
		if !%LockOnSound.playing:
				%LockOnSound.play()
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
		%LockOnSound.playing = false
		rotation = lerp_angle(rotation, initial_rotation,delta/3)
	
	move_and_slide()

func _on_player_detection_body_entered(_body):
	follow = true

func _on_player_detection_body_exited(_body: Node2D) -> void:
	follow = false








#region irrelevent code


#Irrelevant code 
#		rotation = lerp_angle(rotation,rotation+angle,delta)
	#velocity = Vector2(0,randf_range(-speed,-speed*5)).rotated(get_angle_to(player))
	#look_at(player.global_position)




#For future use,
#if move_and_collide(Vector2(0,speed*delta)):
		#if move_and_collide(Vector2(0,speed*delta)).get_collider().name == "PlayerSpaceship":
			#end game

#endregion
