extends CharacterBody2D

# Enemy properties

var speed := 200.0  # Adjust this for the enemy's movement speed
var cloaked := false


func _physics_process(_delta):
	velocity = speed * Vector2.UP
	move_and_slide()



func _on_cloak_timer_timeout() -> void:
	if !cloaked:
		%AnimationPlayer.play("cloak")
		%CloakTimer.wait_time = 5
#		if GameState.hard_mode:
#			pass
#		else:
#			cloaked = true
#	else:
#		%CloakTimer.wait_time = 1
#		%AnimationPlayer.play("uncloak")
#		cloaked = false

