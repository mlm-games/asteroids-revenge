extends RigidBody2D  

@export var health:int
var speed:float = self.linear_velocity.y

var lifetime : int = 100

var velocity : Vector2 = Vector2(0,randf_range(speed,speed*4))

func _ready() -> void:
	gravity_scale = 0
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(_delta: float) -> void:
	linear_velocity = velocity


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()
