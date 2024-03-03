extends CharacterBody2D

signal game_over
signal hit

const SPEED = 400.0

var bullets_fired := 0

@export var rock_bullet_scene:PackedScene 

func _physics_process(delta):
	if visible:
		%Sprite2D.rotation += delta
		var direction = Input.get_vector("left", "right","up","down")
		velocity = direction * SPEED
		velocity.y /= 2
		move_and_slide()
		
		if Input.is_action_just_pressed("fire"):
			shoot()

func shoot():
	#Here we dont know the exact value of rotation as its spinning, so tweens should be used.
	%AnimationPlayer.play("fire")
	var rock_bullet = rock_bullet_scene.instantiate()
	rock_bullet.global_position = %Sprite2D.global_position + Vector2(0,50) 
	get_node("/root").add_child(rock_bullet)
	bullets_fired+=1
	if bullets_fired > 5:
		#Player gets hit for every 5 bullets he fires
		hit.emit()
		hit_effects()


func _on_visible_on_screen_notifier_2d_screen_exited():
	game_over.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() == get_node("/root/World/Enemies"):  # Check collision with obstacles only
		hit.emit()
		body.queue_free()
		hit_effects()


func hit_effects():
	bullets_fired = 0
	$DeathSound.play()
	var tween = $Sprite2D.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite2D,"modulate",Color.RED,0.1)
	tween.tween_property($Sprite2D,"modulate",Color.WHITE,0.1)
	Engine.time_scale = 0.2
	if GameState.lives != 0: #Dont slow time on last hit
		await tween.finished
		$DeathSound.stop()
	Engine.time_scale = 1
