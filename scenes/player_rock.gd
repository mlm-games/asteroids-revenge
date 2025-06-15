class_name Player extends CharacterBody2D

signal game_over
signal hit
signal bullet_fired(bullets_fired: int)
signal bullets_reset

const SPEED = 400.0
const MAX_BULLETS = 5

var force_field : bool = false
var bullets_fired : int = 0

@export var rock_bullet_scene: PackedScene 

func _ready() -> void:
	if GameState.hard_mode:
		$Sprite2D.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/Meteors/meteorGrey_big1.png")

func _physics_process(delta: float) -> void:
	if visible:
		%Sprite2D.rotation += delta * PI/2
		var direction : Vector2 = Input.get_vector("left", "right","up","down")
		if GameState.player_alt_touch_controls:
			velocity.x = direction.x * SPEED
			velocity.y = SPEED/2 
			velocity *= abs(velocity.normalized())
		else:
			velocity = direction * SPEED
			velocity.y /= 2
		move_and_slide()
		
		if Input.is_action_just_pressed("fire"):
			shoot()

func shoot() -> void:
	#Here we dont know the exact value of rotation as its spinning, so tweens should be used. (just an example, not needed here)
	if bullets_fired < MAX_BULLETS:
		%AnimationPlayer.play("fire")
		var rock_bullet : Node = rock_bullet_scene.instantiate()
		rock_bullet.global_position = %Sprite2D.global_position + Vector2(0,50) 
		get_node("/root").add_child(rock_bullet)
		bullets_fired += 1
		bullet_fired.emit(bullets_fired)
		%SpawnSound.play()
	else:
		#Player gets hit for every 5 bullets he fires (so he can fire inf?)
		pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	game_over.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
		hit.emit()
		hit_effects()


func hit_effects() -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	%InvincibilityTimer.start()
	bullets_fired = 0
	bullets_reset.emit()
	$DeathSound.play()
	var tween := %Sprite2D.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(%Sprite2D,"modulate",Color.RED,0.1)
	tween.tween_property(%Sprite2D,"modulate",Color.WHITE,0.1)
	Engine.time_scale = 0.2
	if get_parent().lives != 0: # Don't slow time on last hit
		await tween.finished
		$DeathSound.stop()
		fade_in_out()
	else:
		HitEffects.spawn_player_hurt_particles(self)
	Engine.time_scale = 1
	
	


func fade_in_out() -> void:
	if !%InvincibilityTimer.is_stopped():
		var tween : Tween = %Sprite2D.create_tween()
		tween.tween_property(%Sprite2D, "modulate", Color.TRANSPARENT, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(%Sprite2D, "modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(fade_in_out)

func _on_invincibility_timer_timeout() -> void:
	%Area2D/CollisionShape2D.disabled = false

func refresh_for_boss_rush() -> void:
	bullets_fired = 0
	bullets_reset.emit()
	
	var tween : Tween = %Sprite2D.create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Sprite2D, "modulate", Color.GREEN, 0.3)
	tween.tween_property(%Sprite2D, "modulate", Color.WHITE, 0.3)
	
