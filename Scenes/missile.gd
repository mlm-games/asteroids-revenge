extends CharacterBody2D

 
#TODO: Forcefield powerup? like setting speed to -ve in direction * speed
#@export var health:int = 15

var follow:=false

@export var speed:float

@onready var player = get_node("/root/World/PlayerRock")

func _ready():
	%SmokeTrail.play("default")

func _process(delta):
	velocity = Vector2(0,randf_range(-speed,-speed*5))
	var direction = global_position.direction_to(player.global_position)
	var angle = direction.angle_to(Vector2.RIGHT)
	if follow:
		if !%LockOnSound.playing:
				%LockOnSound.play()
		velocity.x = direction.x * speed
		#print(angle)
		if angle > PI/2:
			rotation = max(deg_to_rad(-120), lerp_angle(rotation,angle,delta/1.5))
		elif angle > 0:
			rotation = min(-PI/3, lerp_angle(rotation,angle,delta/1.5))
	elif !follow:
		%LockOnSound.playing = false
		rotation = lerp_angle(rotation,3*PI/2,delta/1.5)
	
	move_and_slide()


func _on_player_detection_body_entered(_body):
	follow = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	follow = false








#region comments


#Irrelevant code 
#		rotation = lerp_angle(rotation,rotation+angle,delta)
	#velocity = Vector2(0,randf_range(-speed,-speed*5)).rotated(get_angle_to(player))
	#look_at(player.global_position)


#todo: Collision bouncing in the direction of collision direction

#For future use,
#if move_and_collide(Vector2(0,speed*delta)):
		#if move_and_collide(Vector2(0,speed*delta)).get_collider().name == "PlayerSpaceship":
			#get_tree().change_scene_to_file("res://Scenes/main.tscn")

#endregion
