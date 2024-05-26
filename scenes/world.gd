extends Node2D
#FIXME: Convert audio files to check if they work (to .wav?), or find a solution to the poping of audio for fdroid files.

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?

#HACK: Missile only Forcefield powerup? like setting speed to -ve in direction * speed (easy mode? like in libre-memory-game)

var score := 0
var obstacle_type := Vector2i(1,1)
var spawntime = Vector2(0.5, 1.5)
var highscore := GameState.highscore
var lowestscore := GameState.lowestscore
var particles_spawn_count: int
var initial_lives := 3

@onready var boss_spawn_node = %Camera2D2

func _ready() -> void:
	%HUD.update_lives(initial_lives)
	if GameState.hard_mode:
		$HardModeLabel.show()


func _on_player_rock_hit() -> void:
	take_life()


func take_life():
	GameState.lives -= 1
	%HUD.update_lives(GameState.lives)
	if GameState.lives <= 0:
		_on_player_spaceship_game_over() 
		return  # Early exit after emitting game over


func _process(_delta):
	if boss_spawn_node.get_child_count() == 0 && %SpawnTimer.is_stopped() && %PlayerRock.visible:
		%SpawnTimer.start()
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		var initial_vol = %PlayerRock/BGM.volume_db
		%PlayerRock/BGM.volume_db = -80
		tween.tween_property(%PlayerRock/BGM, "volume_db", initial_vol, 1.0)
		%PlayerRock/BGM.play()
	%Camera2D2.global_position.y = %PlayerRock.global_position.y
	score_counter()
	if GameState.hard_mode:
		score_dependencies_hard_mode()
	else:
		score_dependencies()

func _on_spawn_timer_timeout():
	%SpawnTimer.wait_time = randf_range(spawntime.x,spawntime.y)
	var obstacle:Obstacles = load("res://resources/obstacle" + str(randi_range(obstacle_type.x,obstacle_type.y)) + ".tres")
	var projectile_scene = obstacle.scene.instantiate()
	var projectile_scene_spawn_location = %PlayerRock/ProjectilePath/ProjectileSpawnLocation
	projectile_scene_spawn_location.progress_ratio = randf()
	projectile_scene.global_position = projectile_scene_spawn_location.global_position
	projectile_scene.add_to_group("enemies")
	if %Enemies:
		%Enemies.add_child(projectile_scene)
	%SpawnFireSound.play()


func _on_player_spaceship_game_over():
	%SpawnTimer.stop()
	%PlayerRock/BGM.stop()
	%PlayerRock/DeathSound.play()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", true)
	%PlayerRock.hide()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("Boss", "queue_free")
	%HUD.game_over(score)
	particles_spawn_count = randi_range(2,4)
	#the small particles after dying
	for i in range(particles_spawn_count):
		var mini_asteroid = load("res://scenes/mini_asteroid.tscn").instantiate()
		var random_offset = Vector2(randf() * 20, randf() * 20)  # Random offset around player
		mini_asteroid.global_position = %PlayerRock.global_position + random_offset
		get_tree().current_scene.add_child(mini_asteroid)
		# Create tween to fade out and delete
		var tween = mini_asteroid.create_tween().set_parallel()
		tween.tween_property(mini_asteroid,"position", %PlayerRock.global_position + Vector2(300 * randf_range(-1,1), 300 * randf_range(-1,1)),2.0)
		tween.tween_property(mini_asteroid,"rotation", TAU, 2.0)
		tween.tween_property(mini_asteroid, "modulate", Color.TRANSPARENT, 2.0)
		tween.chain().tween_callback(func(): mini_asteroid.queue_free())  # Delete after fading


func score_counter() -> void:
	score = (%PlayerRock.position.y)*0.05
	if GameState.hard_mode:
		GameState.frenzy_high_score = max(GameState.frenzy_high_score,score)
		GameState.frenzy_lowest_score = min(GameState.frenzy_lowest_score,score)
		%HUD.update_score(score,GameState.frenzy_high_score,GameState.frenzy_lowest_score)
	else:
		GameState.highscore = max(GameState.highscore,score)
		GameState.lowestscore = min(GameState.lowestscore,score)
		%HUD.update_score(score,GameState.highscore,GameState.lowestscore)

func score_dependencies():
	var abs_score = abs(score)
	match abs_score:
		50:
			spawntime = Vector2(0.5,1.4)
		100:
			obstacle_type.y = 2
			obstacle_type.x = 2
			spawntime = Vector2(0.5,1.4)
		150:
			spawntime = Vector2(0.5,1.3)
		200:
			obstacle_type.x = 1
			spawntime = Vector2(0.5,1.2)
		250:
			spawntime = Vector2(0.5,1.1)
		350:
			spawntime = Vector2(0.5,1)
		400:
			spawntime = Vector2(0.4,0.9)
		500:
			spawntime = Vector2(0.4,0.8)
			obstacle_type.y = 3
		600:
			obstacle_type.y = 4
			obstacle_type.x = 4
			spawntime = Vector2(0.5,1)
		700:
			spawntime = Vector2(0.4,0.6)
			obstacle_type.x = 1
		1000:
			if boss_spawn_node.get_child_count() == 0:
				var boss = load("res://scenes/boss_spaceship.tscn").instantiate()
				boss.position.x = boss_spawn_node.position.x
				boss_spawn_node.add_child(boss)
				%SpawnTimer.stop()
				%PlayerRock/BGM.stop()
		1200:
			obstacle_type.y = 6

func score_dependencies_hard_mode():
	var abs_score = abs(score)
	match abs_score:
		50:
			spawntime = Vector2(0.5,1)
		100:
			obstacle_type.y = 2
			obstacle_type.x = 2
			spawntime = Vector2(0.5,0.9)
		200:
			obstacle_type.x = 1
			spawntime = Vector2(0.5,0.85)
		300:
			obstacle_type.y = 3
			spawntime = Vector2(0.4,0.75)
		400:
			spawntime = Vector2(0.5,0.65)
			obstacle_type.x = 4
			obstacle_type.y = 4
		500:
			spawntime = Vector2(0.3,0.6)
			obstacle_type.x = 1
		600:
			spawntime = Vector2(0.4,0.7)
			obstacle_type.x = 5
			obstacle_type.y = 5
		700:
			spawntime = Vector2(0.4, 0.6)
			obstacle_type.x = 1
		800:
			obstacle_type.x = 6
			obstacle_type.y = 6
		900:
			obstacle_type.x = 1
		1000:
			if boss_spawn_node.get_child_count() == 0:
				var boss = load("res://scenes/boss_spaceship.tscn").instantiate()
				boss.position.x = boss_spawn_node.position.x
				boss_spawn_node.add_child(boss)
				%SpawnTimer.stop()
				%PlayerRock/BGM.stop()

