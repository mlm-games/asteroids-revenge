extends BaseObstacle

@onready var angle : float = randf_range(PI/2,-PI/2)

func _ready() -> void:
	super._ready()
	%VisibleOnScreenNotifier2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	#velocity = (Vector2.DOWN * speed).rotated(randf_range(-PI / 4, PI / 4))
	
	rotation = snappedf(randf_range(-PI/4,PI/4),PI/4)
	if GameState.hard_mode:
		rotation = randf_range(-PI/2,PI/2)


func _physics_process(_delta: float) -> void:
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
	
