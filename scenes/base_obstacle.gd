class_name BaseObstacle extends CharacterBody2D

@export var speed: float = 200.0

signal destroyed

func _ready() -> void:
	%VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

# All obstacles will use move_and_slide(), so we can define the main loop here.
# Child classes will override _physics_process to change the 'velocity' vector.
func _physics_process(delta: float) -> void:
	# Base implementation is just simple movement.
	# Children will override this to add their unique logic.
	velocity = Vector2.DOWN * speed
	move_and_slide()

func on_hit_by_player_bullet() -> void:
	# add the hit effect here.
	destroyed.emit()
	queue_free()
