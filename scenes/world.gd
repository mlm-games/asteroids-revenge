class_name World extends Node2D

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?

#HACK: Missile only Forcefield powerup? like setting speed to -ve in direction * speed (easy mode? like in libre-memory-game)

const MiniAsteroidScene : PackedScene = preload("res://scenes/mini_asteroid.tscn")
const BOSS_SPACESHIP_PATH : StringName = 'res://scenes/boss_spaceship.tscn'

const PARTICLE_SPAWN_OFFSET : int = 20
const MIN_PARTICLES : int = 2
const MAX_PARTICLES : int = 4
const INITIAL_LIVES : int = 3

signal boss_rush_next_level

@export var progression: LevelProgression

var current_stage_index := 0

var lives: int = 3

var score : int = 0
var obstacle_type : Vector2i = Vector2i(1, 1)
var spawntime : Vector2 = Vector2(0.5, 1.5)
var particles_spawn_count: int
var difficulty_level_method : Callable = score_dependencies_hard_mode if GameState.hard_mode else score_dependencies
var active_bosses: Array[Node2D] = []

@onready var boss_spawn_node : Camera2D = %Camera2D2
@onready var boss_rush_label: Label = %BossRushLabel

func _ready() -> void:
	%SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	%PlayerRock.hit.connect(take_life)
	%PlayerRock.bullets_reset.connect(%HUD.update_bullets_bar.bind(0))
	%PlayerRock.bullet_fired.connect(%HUD.update_bullets_bar)
	%PlayerRock.game_over.connect(_on_player_spaceship_game_over)
	
	lives = INITIAL_LIVES
	%HUD.update_lives(lives)
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
	#TODO: remove the long dep methods
	#if current_stage_index < progression_stages.size() - 1:
		#if score >= progression_stages[current_stage_index + 1].score_threshold:
			#current_stage_index += 1
			#var new_stage = progression_stages[current_stage_index]
			#%SpawnTimer.wait_time = randf_range(new_stage.spawn_time_min, new_stage.spawn_time_max)
			#print("Advanced to stage ", current_stage_index)

#TODO: update
#func spawn_obstacle():
	#var current_stage = progression_stages[current_stage_index]
	#if current_stage.available_obstacles.is_empty():
		#return # No obstacles to spawn for this stage
#
	## Pick a random scene from this stage's specific list
	#var obstacle_scene: PackedScene = current_stage.available_obstacles.pick_random()
	#var new_obstacle = obstacle_scene.instantiate()

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


func take_life() -> void:
	lives -= 1
	%HUD.update_lives(lives)
	if lives <= 0:
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
	for i: int in range(particles_spawn_count):
		var mini_asteroid : Sprite2D = MiniAsteroidScene.instantiate()
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
			if not is_boss_present(): spawn_boss()
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
		1000: if not is_boss_present(): spawn_boss()

func spawn_boss() -> void:
	 #if active_bosses.size() >= MAX_BOSSES: return

	var boss_scene := load(BOSS_SPACESHIP_PATH)
	var new_boss : CharacterBody2D = boss_scene.instantiate()
	
	new_boss.died.connect(_on_boss_died.bind(new_boss))
	
	boss_spawn_node.add_child(new_boss)
	active_bosses.append(new_boss)
	print("Spawned a boss. Total active: ", active_bosses.size())

func _on_boss_died(boss_instance: Node2D) -> void:
	if active_bosses.has(boss_instance):
		active_bosses.erase(boss_instance)
	
	print("A boss was defeated. Total remaining: ", active_bosses.size())
	
	# If in boss rush and all bosses are gone, spawn the next wave
	if GameState.boss_rush_mode and active_bosses.is_empty():
		boss_defeated()

func boss_defeated() -> void:
	await get_tree().create_timer(7).timeout # Wait for death anim
	
	if GameState.boss_rush_mode:
		if not is_boss_present():
			GameState.next_boss_level()
			GameState.max_boss_rush_level = maxi(GameState.max_boss_rush_level, GameState.boss_rush_level)
			
			%PlayerRock.refresh_for_boss_rush()
			
			if lives < INITIAL_LIVES:
				lives = INITIAL_LIVES
				%HUD.update_lives(lives)
			
			spawn_boss()
			
			if GameState.boss_rush_mode: boss_rush_label.text = tr("GAMEPLAY_BOSS_RUSH_LEVEL_LABEL") + " " + str(GameState.boss_rush_level)


"""
func _on_game_restarted() -> void:
	# Reset game state
	lives = INITIAL_LIVES
	score = 0
	%PlayerRock.bullets_fired = 0
	%PlayerRock.show()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", false)
	%SpawnTimer.start()
	
	# Update HUD
	%HUD.update_lives(lives)
	%HUD.update_score(score, GameState.highscore, GameState.lowestscore)
	%HUD.update_bullets_bar(0)
	
	# Reset difficulty
	obstacle_type = Vector2i(1, 1)
	spawntime = Vector2(0.5, 1.5)
	
	# Restart background music
	fade_in_bgm()
"""
