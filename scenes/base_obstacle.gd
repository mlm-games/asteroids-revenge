class_name BaseObstacle extends CharacterBody2D

@export var speed: float = 200.0

signal destroyed

func _ready() -> void:
	%LifetimeTimer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	# Children have to override this to add their unique logic.
	velocity = Vector2.RIGHT * speed
	move_and_slide()

func on_hit_by_player_bullet() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	%Sprite2D.hide()
	%AnimationPlayer.play("death")
	destroyed.emit()
	
	await %AnimationPlayer.animation_finished
	queue_free()
