extends Node2D

var score := 0
var minobs:= 1
var maxobs:int=1
var spawntime = Vector2(0.5,1.5)
var highscore = GameState.highscore
var lowestscore = GameState.lowestscore

#You are a spaceship travelling along an asteriod belt trying to find what seems to be an anomaly,You get switched up into an asteriod but can move like an spaceship, when you try to reach back to your spacemates, they cant hear you and uh oh, looks like a fleet is firing at your asteriod belt. Will you live to tell your tale another day?

func _ready():
	GameState.loadgame()

func _process(_delta):
	score_counter()
	score_dependencies()

func _on_spawn_timer_timeout():
	%SpawnTimer.wait_time = randf_range(spawntime.x,spawntime.y)
	var obstacle:Obstacles = load("res://Resources/obstacle" + str(randi_range(minobs,maxobs)) + ".tres")
	var projectile_scene = obstacle.scene.instantiate()
	var projectile_scene_spawn_location = %PlayerRock/ProjectilePath/ProjectileSpawnLocation
	projectile_scene_spawn_location.progress_ratio = randf()
	projectile_scene.global_position = projectile_scene_spawn_location.global_position
	%Enemies.add_child(projectile_scene)
	%SpawnFireSound.play()

## Maybe TODOs
#TODO: when missile hits, explodes into small rocks like sky balloon DX

func _on_player_spaceship_game_over():
	%SpawnTimer.stop()
	%PlayerRock/BGM.stop()
	%PlayerRock/DeathSound.play()
	%PlayerRock/CollisionShape2D.set_deferred("disabled", true)
	%PlayerRock.hide()
	%Enemies.hide()
	%HUD.game_over(score)
	GameState.savegame()

func score_counter() -> void:
	score = (%PlayerRock.global_position.y - 583)*0.05
	highscore = max(highscore,score)
	lowestscore = min(lowestscore,score)
	%HUD.update_score(score,highscore,lowestscore)

func score_dependencies():
	var absolutescore = abs(score)
	match absolutescore:
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
			spawntime = Vector2(0.4,0.6)
		700:
			spawntime = Vector2(0.5,1)
			maxobs = 4

func score_dependencies_death_mode():
	pass
