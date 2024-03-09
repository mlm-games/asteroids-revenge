extends CharacterBody2D

const SHAPESHIP_TYPE = ["blue", "green", "orange", "red"]

var speed := 100.0
var horizontal_range := Vector2(50.0,600.0)
var idle_duration_range := Vector2(1.0, 3.0)
var shoot_interval_range := Vector2(1.5, 3.0)
var health := 100.0
var target_position := Vector2(randi_range(0,600),800)

const MAX_HEALTH = 100
@onready var timer = get_tree().create_timer(1.5)

func _ready() -> void:
	health = MAX_HEALTH
	%Sprite2D.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/playerShip" +str(randi_range(1,3)) + "_" + SHAPESHIP_TYPE.pick_random() + ".png")
	%Sprite2D/ApproachAnim.play("approach")

func _process(delta: float) -> void:
	position = lerp(position, target_position, delta * 2.0)
	%BossHealthBar.value = health



func shoot() -> void:
	var boss_obstacle := load("res://resources/obstacle"+str(randi_range(7,9))+".tres")
	var bullet = boss_obstacle.scene.instantiate()
	bullet.global_position = %ProjectileSpawnPoint.global_position
	get_node("/root").add_child(bullet)
	bullet.add_to_group("enemies")
	%FireSound.play()
	if health > 20: 
		take_damage(5)
	else:
		take_damage(2)

func _on_shoot_timer_timeout() -> void:
	%ShootTimer.wait_time = randf_range(shoot_interval_range.x, shoot_interval_range.y) - (MAX_HEALTH-health)/100
	shoot()

func take_damage(damage: float) -> void:
	health = max(health - damage, 0)
	if health > 0:
		var tween = create_tween()
		tween.tween_property(%Sprite2D, "modulate", Color.RED, 0.2)
		tween.tween_property(%Sprite2D, "modulate", Color.WHITE, 0.2)
	else:
		GameState.boss_defeated = true
		queue_free()
#invincibility statw




func _on_idle_timer_timeout() -> void:
	%IdleTimer.wait_time = randf_range(idle_duration_range.x,idle_duration_range.y)
	target_position = Vector2(randf_range(horizontal_range.x, horizontal_range.y),800)
