class_name HitEffects extends Node2D

static func spawn_player_hurt_particles(parent_node: Node2D) -> void:
	var particles_spawn_count : int = randi_range(3, 5)
	for i:int in range(particles_spawn_count):
		var mini_asteroid := World.MiniAsteroidScene.instantiate()
		var random_offset := Vector2(randf() * World.PARTICLE_SPAWN_OFFSET, randf() * World.PARTICLE_SPAWN_OFFSET)
		mini_asteroid.global_position = parent_node.global_position + random_offset
		parent_node.add_child(mini_asteroid)
		animate_particle(mini_asteroid)

static func animate_particle(particle: Node2D) -> void:
	var tween : Tween = particle.create_tween().set_parallel().set_ease(Tween.EASE_IN)
	tween.tween_property(particle, "position", particle.position + Vector2(300 * randf_range(-1, 1), 300 * randf_range(-1, 1)), 2.0)
	tween.tween_property(particle, "rotation", TAU, 2.0)
	tween.tween_property(particle, "modulate", Color.TRANSPARENT, 2.0)
	tween.chain().tween_callback(particle.queue_free)
