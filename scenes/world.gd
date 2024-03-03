extends Node2D

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?
#TODO: Collision bouncing in the direction of collision direction for the nextgame
# (Hard mode, enable collision between enemies), see the heartbeast video for making the sawblades balloon game (Collision bouncing in the direction of collision direction)
#TODO: Missile only Forcefield powerup? like setting speed to -ve in direction * speed

var score := 0
var minobs:= 1
var maxobs:int=1
var spawntime = Vector2(0.5,1.5)
var highscore = GameState.highscore
var lowestscore = GameState.lowestscore
var particles_spawn_count:int

func take_life():
	GameState.lives -= 1
	%HUD.update_lives(GameState.lives)
	if GameState.lives <= 0:
		_on_player_spaceship_game_over()  # Emit game over signal
		return  # Early exit after emitting game over



func _process(_delta):
	%HUD/BulletsBar.value = %PlayerRock.bullets_fired
	score_counter()
	if GameState.hard_mode:
		score_dependencies_hard_mode()
	else:
		score_dependencies()

func _on_spawn_timer_timeout():
	%SpawnTimer.wait_time = randf_range(spawntime.x,spawntime.y)
	var obstacle:Obstacles = load("res://resources/obstacle" + str(randi_range(minobs,maxobs)) + ".tres")
	var projectile_scene = obstacle.scene.instantiate()
	var projectile_scene_spawn_location = %PlayerRock/ProjectilePath/ProjectileSpawnLocation
	projectile_scene_spawn_location.progress_ratio = randf()
	projectile_scene.global_position = projectile_scene_spawn_location.global_position
	%Enemies.add_child(projectile_scene)
	%SpawnFireSound.play()


func _on_player_spaceship_game_over():
	%SpawnTimer.stop()
	%PlayerRock/BGM.stop()
	%PlayerRock/DeathSound.play()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", true)
	%PlayerRock.hide()
	if %Enemies:
		%Enemies.queue_free()
	%HUD.game_over(score)
	GameState.save_game()
	particles_spawn_count = randi_range(2,4)
	#the small particles after dying
	for i in range(particles_spawn_count):
		var mini_asteroid = load("res://scenes/mini_asteroid.tscn").instantiate()
		var random_offset = Vector2(randf()*20,randf()*20)  # Random offset around player
		mini_asteroid.global_position = %PlayerRock.global_position + random_offset
		get_tree().current_scene.add_child(mini_asteroid)
		# Create tween to fade out and delete
		var tween = mini_asteroid.create_tween().set_parallel()
		tween.tween_property(mini_asteroid,"position:x", %PlayerRock.global_position.x + 300 * randf_range(-1,1),2.0)
		tween.tween_property(mini_asteroid,"position:y", %PlayerRock.global_position.y + 300 * randf_range(-1,1),2.0)
		tween.tween_property(mini_asteroid,"rotation", TAU, 2.0)
		tween.tween_property(mini_asteroid, "modulate", Color.TRANSPARENT, 2.0)
		tween.chain().tween_callback(mini_asteroid.queue_free)  # Delete after fading


func score_counter() -> void:
	score = (%PlayerRock.global_position.y - 583)*0.05
	highscore = max(highscore,score)
	lowestscore = min(lowestscore,score)
	%HUD.update_score(score,highscore,lowestscore)

func score_dependencies():
	var abs_score = abs(score)
	match abs_score:
		50:
			spawntime = Vector2(0.5,1.4)
		100:
			maxobs = 2
			minobs = 2
			spawntime = Vector2(0.5,1.4)
		150:
			spawntime = Vector2(0.5,1.3)
		200:
			minobs = 1
			spawntime = Vector2(0.5,1.2)
		250:
			spawntime = Vector2(0.5,1.1)
		350:
			spawntime = Vector2(0.5,1)
		400:
			spawntime = Vector2(0.4,0.9)
		500:
			spawntime = Vector2(0.4,0.8)
			maxobs = 3
		600:
			maxobs = 4
			minobs = 4
			spawntime = Vector2(0.5,1)
		700:
			spawntime = Vector2(0.4,0.6)
			minobs = 1

func score_dependencies_hard_mode():
	var abs_score = abs(score)
	match abs_score:
		50:
			spawntime = Vector2(0.5,1)
		100:
			maxobs = 2
			minobs = 2
			spawntime = Vector2(0.5,0.9)
		200:
			minobs = 1
			spawntime = Vector2(0.5,0.85)
		300:
			maxobs = 3
			spawntime = Vector2(0.4,0.75)
		400:
			spawntime = Vector2(0.4,0.65)
		500:
			spawntime = Vector2(0.3,0.6)
			maxobs = 4
		600:
			spawntime = Vector2(0.4,0.7)
			maxobs = 5
		700:
			spawntime = Vector2(0.4, 0.6)
			maxobs = 6


func _on_player_rock_hit() -> void:
	take_life()
