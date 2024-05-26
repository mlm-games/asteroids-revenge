class_name Player extends CharacterBody2D

signal game_over
signal hit

const SPEED = 400.0

var force_field : bool = false
var bullets_fired := 0

@export var rock_bullet_scene:PackedScene 

func _ready() -> void:
	if GameState.hard_mode:
		$Sprite2D.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/Meteors/meteorGrey_big1.png")

func _physics_process(delta):
	if visible:
		%Sprite2D.rotation += delta * PI/2
		var direction = Input.get_vector("left", "right","up","down")
		velocity = direction * SPEED
		velocity.y /= 2
		move_and_slide()
		
		if Input.is_action_just_pressed("fire"):
			shoot()

func shoot():
	#Here we dont know the exact value of rotation as its spinning, so tweens should be used. (just an example, not needed here)
	if bullets_fired < 5:
		%AnimationPlayer.play("fire")
		var rock_bullet = rock_bullet_scene.instantiate()
		rock_bullet.global_position = %Sprite2D.global_position + Vector2(0,50) 
		get_node("/root").add_child(rock_bullet)
		bullets_fired+=1
	else:
		#Player gets hit for every 5 bullets he fires (so he can fire inf?)
		pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	game_over.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
	  # Check collision with obstacles only
		body.queue_free()
		hit.emit()
		hit_effects()


func hit_effects():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	%InvincibilityTimer.start()
	bullets_fired = 0
	$DeathSound.play()
	var tween = %Sprite2D.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(%Sprite2D,"modulate",Color.RED,0.1)
	#tween.set_parallel().tween_property(%Sprite2D, "scale", scale - Vector2(0.01, 0.01), 0.1)
	tween.tween_property(%Sprite2D,"modulate",Color.WHITE,0.1)
	Engine.time_scale = 0.2
	if GameState.lives != 0: #Dont slow time on last hit
		await tween.finished
		$DeathSound.stop()
		fade_in_out()
	Engine.time_scale = 1


func fade_in_out():
	if !%InvincibilityTimer.is_stopped():
		var tween = %Sprite2D.create_tween()
		tween.tween_property(%Sprite2D, "modulate", Color.TRANSPARENT, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(%Sprite2D, "modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(fade_in_out)

func _on_invincibility_timer_timeout() -> void:
	%Area2D/CollisionShape2D.disabled = false
