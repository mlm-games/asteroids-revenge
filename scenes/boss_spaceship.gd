extends CharacterBody2D

#Player.global_pos + outside viewport to the left = Boss.global pos 

signal died

const SHAPESHIP_TYPE = ["blue", "green", "orange", "red"]

var speed := 100.0
var horizontal_range := Vector2(50.0,600.0)
var idle_duration_range := Vector2(1.0, 3.0)
var shoot_interval_range := Vector2(1.5, 3.0)
var health := 100.0
var target_position := Vector2(randi_range(0,600),800)
var spaceship_color : String = SHAPESHIP_TYPE.pick_random()

const MAX_HEALTH = 100
@onready var timer : SceneTreeTimer = get_tree().create_timer(1.5)
@onready var bgm: AudioStreamPlayer2D = %BGM

func _ready() -> void:
	if GameState.boss_rush_mode:
		health = MAX_HEALTH * GameState.boss_health_multiplier
	else:
		health = MAX_HEALTH
	
	%Sprite2D.texture = load("res://art-and-sound/kenney_space-shooter-redux/PNG/playerShip" +str(randi_range(1,3)) + "_" + spaceship_color + ".png")
	%Sprite2D/ApproachAnim.play("approach")
	
	%BossHealthBar.max_value = health

func _process(delta: float) -> void:
	position = lerp(position, target_position, delta * 2.0)
	%BossHealthBar.value = health



func shoot() -> void:
	var boss_obstacle := load("res://resources/obstacle"+str(randi_range(7,9))+".tres")
	var bullet : Node2D = boss_obstacle.scene.instantiate()
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
	_play_hit_effect()
	if health <= 0:
		_die()

func _play_hit_effect() -> void:
	var tween := create_tween()
	tween.tween_property(%Sprite2D, "modulate", Color.RED, 0.2)
	tween.tween_property(%Sprite2D, "modulate", Color.WHITE, 0.2)

func _die() -> void:
	emit_signal("died") # Let the world handle game logic
	%ShootTimer.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	%DeathSound.play()
	%BossHealthBar.hide()
	%AnimationPlayer.play("death")
	_spawn_debris_particles()
	await %DeathSound.finished
	queue_free()

func _spawn_debris_particles() -> void:
	var part : Array = ["cockpit", "wing"]
	var material_color : String = spaceship_color.capitalize()
	if material_color == "Orange":
		material_color = "Yellow"
	var particles_spawn_count : int = randi_range(1,3)
	%AnimationPlayer.play("death")
	# The particles after death of spaceship
	for i in range(particles_spawn_count):
		randomize()
		var part_path : String = "res://art-and-sound/kenney_space-shooter-redux/PNG/Parts/" + part.pick_random() + material_color + "_" + str(randi_range(0,7)) + ".png"
		var broken_part : Sprite2D = Sprite2D.new()
		var random_offset : Vector2 = Vector2(randf() * 20, randf() * 20)  # Random offset around player
		broken_part.texture = load(part_path)
		broken_part.global_position = %Sprite2D.global_position + random_offset
		get_tree().current_scene.add_child(broken_part)
		# Create tween to fade out and delete
		var tween : Tween = broken_part.create_tween().set_parallel()
		tween.tween_property(broken_part,"position", %Sprite2D.global_position + Vector2(300 * randf_range(-1,1), 300 * randf_range(-1,1)),2.0)
		tween.tween_property(broken_part,"rotation", TAU, 2.0)
		tween.tween_property(broken_part, "modulate", Color.TRANSPARENT, 2.0)
		tween.chain().tween_callback(func() -> void: broken_part.queue_free())  # Delete after fading
#invincibility state




func _on_idle_timer_timeout() -> void:
	%IdleTimer.wait_time = randf_range(idle_duration_range.x,idle_duration_range.y)
	target_position = Vector2(randf_range(horizontal_range.x, horizontal_range.y),800)
