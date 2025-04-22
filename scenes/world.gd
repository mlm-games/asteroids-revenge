class_name World extends Node2D

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?

#HACK: Missile only Forcefield powerup? like setting speed to -ve in direction * speed (easy mode? like in libre-memory-game)

const MiniAsteroidScene = preload("res://scenes/mini_asteroid.tscn")
const BOSS_SPACESHIP_PATH = 'res://scenes/boss_spaceship.tscn'

const PARTICLE_SPAWN_OFFSET = 20
const MIN_PARTICLES = 2
const MAX_PARTICLES = 4
const INITIAL_LIVES = 3

signal boss_rush_next_level

var score := 0
var obstacle_type := Vector2i(1, 1)
var spawntime := Vector2(0.5, 1.5)
var particles_spawn_count: int
var difficulty_level_method := score_dependencies_hard_mode if GameState.hard_mode else score_dependencies

@onready var boss_spawn_node : Camera2D = %Camera2D2
@onready var boss_rush_label: Label = %BossRushLabel

func _ready() -> void:
	GameState.lives = INITIAL_LIVES
	%HUD.update_lives(GameState.lives)
	$HardModeLabel.visible = GameState.hard_mode
	if GameState.boss_rush_mode:
		boss_rush_label.visible = true
		boss_rush_label.text = tr("GAMEPLAY_BOSS_RUSH_LEVEL_LABEL") + " " + str(GameState.boss_rush_level)
		
		spawn_boss()
	
	ResourceLoader.load_threaded_request(BOSS_SPACESHIP_PATH)
	
	# Connect player signals to HUD
	#%PlayerRock.bullet_fired.connect(%HUD._on_player_bullet_fired)
	#%PlayerRock.bullets_reset.connect(%HUD._on_player_bullets_reset)
	#%PlayerRock.hit.connect(_on_player_rock_hit)
	#%PlayerRock.game_over.connect(_on_player_spaceship_game_over)
	
	# Connect HUD signals
	#%HUD.game_restarted.connect(_on_game_restarted)


func _process(_delta: float) -> void:
	handle_boss_spawn()
	update_camera_position_and_projectile_path()
	update_score()
	difficulty_level_method.call()


func handle_boss_spawn() -> void:
	if not is_boss_present() && %SpawnTimer.is_stopped() && %PlayerRock.visible and not GameState.boss_rush_mode:
		%SpawnTimer.start()
		fade_in_bgm()

func is_boss_present() -> bool:
	return boss_spawn_node.get_child_count() != 1

func fade_in_bgm() -> void:
	var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var initial_vol : float = %PlayerRock/BGM.volume_db
	%PlayerRock/BGM.volume_db = -80
	tween.tween_property(%PlayerRock/BGM, "volume_db", initial_vol, 1.0)
	%PlayerRock/BGM.play()


func update_camera_position_and_projectile_path() -> void:
	%Camera2D2.global_position.y = %PlayerRock.global_position.y
	


func update_score() -> void:
	score = (%PlayerRock.position.y) * 0.05
	var high_score : int = GameState.frenzy_high_score if GameState.hard_mode else GameState.highscore
	var low_score : int = GameState.frenzy_lowest_score if GameState.hard_mode else GameState.lowestscore
	high_score = max(high_score, score)
	low_score = min(low_score, score)
	%HUD.update_score(score, high_score, low_score)
	
	if GameState.hard_mode:
		GameState.frenzy_high_score = high_score
		GameState.frenzy_lowest_score = low_score
	elif not GameState.boss_rush_mode:
		GameState.highscore = high_score
		GameState.lowestscore = low_score


func _on_spawn_timer_timeout() -> void:
	%SpawnTimer.wait_time = randf_range(spawntime.x, spawntime.y)
	spawn_obstacle()


func spawn_obstacle() -> void:
	var obstacle: Obstacles = load("res://resources/obstacle" + str(randi_range(obstacle_type.x, obstacle_type.y)) + ".tres")
	var projectile_scene : Node = obstacle.scene.instantiate()
	var spawn_location : PathFollow2D = %ProjectilePath/ProjectileSpawnLocation
	spawn_location.progress_ratio = randf()
	projectile_scene.global_position = spawn_location.global_position
	projectile_scene.add_to_group("enemies")
	%Enemies.add_child(projectile_scene)
	%SpawnFireSound.play()


func _on_player_rock_hit() -> void:
	take_life()


func take_life() -> void:
	GameState.lives -= 1
	%HUD.update_lives(GameState.lives)
	if GameState.lives <= 0:
		_on_player_spaceship_game_over()

func _on_player_spaceship_game_over() -> void:
	stop_game_effects()
	play_death_effects()
	cleanup_entities()
	show_game_over_screen()
	spawn_death_particles()
	Transition.camera_shake(5, 2.5, 5)


func stop_game_effects() -> void:
	%SpawnTimer.stop()
	%PlayerRock/BGM.stop()

func play_death_effects() -> void:
	%PlayerRock/DeathSound.play()

func cleanup_entities() -> void:
	%PlayerRock/CollisionShape2D.set_deferred("disabled", true)
	%PlayerRock.hide()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("Boss", "queue_free")

func show_game_over_screen() -> void:
	%HUD.game_over(score)

func spawn_death_particles() -> void:
	particles_spawn_count = randi_range(MIN_PARTICLES, MAX_PARTICLES)
	for i in range(particles_spawn_count):
		var mini_asteroid := MiniAsteroidScene.instantiate()
		var random_offset : Vector2 = Vector2(randf() * PARTICLE_SPAWN_OFFSET, randf() * PARTICLE_SPAWN_OFFSET)
		mini_asteroid.global_position = %PlayerRock.global_position + random_offset
		add_child(mini_asteroid)
		animate_death_particle(mini_asteroid)

func animate_death_particle(particle: Node2D) -> void:
	var tween : Tween = create_tween().set_parallel()
	tween.tween_property(particle, "position", %PlayerRock.global_position + Vector2(300 * randf_range(-1, 1), 300 * randf_range(-1, 1)), 2.0)
	tween.tween_property(particle, "rotation", TAU, 2.0)
	tween.tween_property(particle, "modulate", Color.TRANSPARENT, 2.0)
	tween.chain().tween_callback(particle.queue_free)

func score_dependencies() -> void:
	var abs_score : int = absi(score)
	match abs_score:
		50: spawntime = Vector2(0.5, 1.4)
		100:
			obstacle_type = Vector2i(2, 2)
			spawntime = Vector2(0.5, 1.4)
		150: spawntime = Vector2(0.5, 1.3)
		200:
			obstacle_type.x = 1
			spawntime = Vector2(0.5, 1.2)
		250: spawntime = Vector2(0.5, 1.1)
		350: spawntime = Vector2(0.5, 1)
		400: spawntime = Vector2(0.4, 0.9)
		500:
			spawntime = Vector2(0.4, 0.8)
			obstacle_type.y = 3
		600:
			obstacle_type = Vector2i(4, 4)
			spawntime = Vector2(0.5, 1)
		700:
			spawntime = Vector2(0.4, 0.6)
			obstacle_type.x = 1
		1000: 
			spawn_boss()
		1200: 
			obstacle_type.y = 6

func score_dependencies_hard_mode() -> void:
	var abs_score :int = absi(score)
	match abs_score:
		50: spawntime = Vector2(0.5, 1)
		100:
			obstacle_type = Vector2i(2, 2)
			spawntime = Vector2(0.5, 0.9)
		200:
			obstacle_type.x = 1
			spawntime = Vector2(0.5, 0.85)
		300:
			obstacle_type.y = 3
			spawntime = Vector2(0.4, 0.75)
		400:
			spawntime = Vector2(0.5, 0.65)
			obstacle_type = Vector2i(4, 4)
		500:
			spawntime = Vector2(0.3, 0.6)
			obstacle_type.x = 1
		600:
			spawntime = Vector2(0.4, 0.7)
			obstacle_type = Vector2i(5, 5)
		700:
			spawntime = Vector2(0.4, 0.6)
			obstacle_type.x = 1
		800: obstacle_type = Vector2i(6, 6)
		900: obstacle_type.x = 1
		1000: spawn_boss()

func spawn_boss() -> void:
	#if GameState.boss_rush_mode:
		
		
	if not is_boss_present():
		var boss : CharacterBody2D = ResourceLoader.load_threaded_get(BOSS_SPACESHIP_PATH).instantiate() if !GameState.boss_rush_mode else load(BOSS_SPACESHIP_PATH).instantiate()
		boss.position.x = boss_spawn_node.position.x
		boss_spawn_node.add_child(boss)
		%SpawnTimer.stop()
		%PlayerRock/BGM.stop()


func boss_defeated() -> void:
	if GameState.boss_rush_mode:
		GameState.next_boss_level()
		GameState.max_boss_rush_level = maxi(GameState.max_boss_rush_level, GameState.boss_rush_level)
		
		%PlayerRock.refresh_for_boss_rush()
		
		if GameState.lives < INITIAL_LIVES:
			GameState.lives = INITIAL_LIVES
			%HUD.update_lives(GameState.lives)
		
		await get_tree().create_timer(7).timeout # Wait for death anim
		spawn_boss()
		
		if GameState.boss_rush_mode: boss_rush_label.text = tr("GAMEPLAY_BOSS_RUSH_LEVEL_LABEL") + " " + str(GameState.boss_rush_level)


"""
func _on_game_restarted() -> void:
	# Reset game state
	GameState.lives = INITIAL_LIVES
	score = 0
	%PlayerRock.bullets_fired = 0
	%PlayerRock.show()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", false)
	%SpawnTimer.start()
	
	# Update HUD
	%HUD.update_lives(GameState.lives)
	%HUD.update_score(score, GameState.highscore, GameState.lowestscore)
	%HUD.update_bullets_bar(0)
	
	# Reset difficulty
	obstacle_type = Vector2i(1, 1)
	spawntime = Vector2(0.5, 1.5)
	
	# Restart background music
	fade_in_bgm()
"""
