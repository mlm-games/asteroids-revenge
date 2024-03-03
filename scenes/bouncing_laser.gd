extends CharacterBody2D

@export var speed : float
@onready var angle = randf_range(PI/2,-PI/2)

func _ready() -> void:
	
	rotation = snappedf(randf_range(-PI/4,PI/4),PI/4)
	if GameState.hard_mode:
		rotation = randf_range(-PI/2,PI/2)


func _physics_process(delta: float) -> void:
	velocity = Vector2(0,-speed).rotated(rotation)
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if GameState.hard_mode:
		if velocity.x > 0:
			rotation -= angle + PI/2
		else:
			rotation += angle + PI/2
	else:
		if  velocity.x > 0:
			rotation += 3*PI/2
		else:
			rotation -= 3*PI/2
	
