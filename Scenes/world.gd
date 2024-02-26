extends Node2D

var score := 0
var minobs:= 1
var maxobs:int=1
var spawntime:float = randf_range(0.5,1.5)

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?

func _ready():
	GameState.loadgame()

func _process(_delta):
	score_counter()
	score_dependencies()
#	print(%SpawnTimer.wait_time)
	

func _on_spawn_timer_timeout():
	%SpawnTimer.wait_time = spawntime
	var obstacle:Obstacles = load("res://Resources/obstacle" + str(randi_range(minobs,maxobs)) + ".tres")
	var projectile_scene = obstacle.scene.instantiate()
	var projectile_scene_spawn_location = %PlayerRock/ProjectilePath/ProjectileSpawnLocation
	projectile_scene_spawn_location.progress_ratio = randf()
	projectile_scene.global_position = projectile_scene_spawn_location.global_position
	$Enemies.add_child(projectile_scene)

## Maybe TODOs
#TODO: when missile hits, explodes into small rocks like sky balloon DX

func _on_player_spaceship_game_over():
	%PlayerRock/BGM.stop()
	%PlayerRock/DeathSound.play()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", true)
	%PlayerRock.hide()
	$Enemies.hide()
	$HUD.game_over(score)
	GameState.savegame()

func score_counter() -> void:
	score = (%PlayerRock.global_position.y - 583)*0.05
	GameState.highscore = max(GameState.highscore,score)
	GameState.lowestscore = min(GameState.lowestscore,score)
	$HUD.update_score(score,GameState.highscore,GameState.lowestscore)

func score_dependencies():
	var absolutescore = abs(score)
	match absolutescore:
		absolutescore when absolutescore > 0 && absolutescore < 50:
			spawntime = randf_range(0.5,1.4)
		absolutescore when absolutescore > 50 && absolutescore < 100:
			maxobs = 2
			minobs = 2
			spawntime = randf_range(0.5,1.4)
		absolutescore when absolutescore > 100 && absolutescore < 150:
			spawntime = randf_range(0.5,1.3)
		absolutescore when absolutescore > 150 && absolutescore < 200:
			minobs = 1
			spawntime = randf_range(0.5,1.2)
		absolutescore when absolutescore > 200 && absolutescore < 250:
			spawntime = randf_range(0.5,1.1)
		absolutescore when absolutescore > 300 && absolutescore < 350:
			spawntime = randf_range(0.5,1)
		absolutescore when absolutescore > 350 && absolutescore < 400:
			spawntime = randf_range(0.4,0.9)
		absolutescore when absolutescore > 400 && absolutescore < 500:
			spawntime = randf_range(0.4,0.8)
			maxobs = 3
		absolutescore when absolutescore > 500 && absolutescore < 600:
			spawntime = randf_range(0.4,0.6)

func score_dependencies_hard_mode():
	var absolutescore = abs(score)
	match absolutescore:
		absolutescore when absolutescore > 0 && absolutescore < 50:
			spawntime = randf_range(0.5,1.4)
		absolutescore when absolutescore > 50 && absolutescore < 100:
			maxobs = 2
			minobs = 2
			spawntime = randf_range(0.5,1.4)
		absolutescore when absolutescore > 100 && absolutescore < 150:
			spawntime = randf_range(0.5,1.3)
		absolutescore when absolutescore > 150 && absolutescore < 200:
			minobs = 1
			spawntime = randf_range(0.5,1.2)
		absolutescore when absolutescore > 200 && absolutescore < 250:
			spawntime = randf_range(0.5,1.1)
		absolutescore when absolutescore > 300 && absolutescore < 350:
			spawntime = randf_range(0.5,1)
		absolutescore when absolutescore > 350 && absolutescore < 400:
			spawntime = randf_range(0.4,0.9)
		absolutescore when absolutescore > 400 && absolutescore < 500:
			spawntime = randf_range(0.4,0.8)
			maxobs = 3
		absolutescore when absolutescore > 500 && absolutescore < 600:
			spawntime = randf_range(0.4,0.6)
