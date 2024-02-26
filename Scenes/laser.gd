extends RigidBody2D  

@export var health:int
var speed:float = self.linear_velocity.y

var lifetime = 100

var velocity = Vector2(0,randf_range(speed,speed*4))

func _ready():
	gravity_scale = 0
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(_delta):
	linear_velocity = velocity



#todo: Collision bouncing in the direction of collision direction

#For future use,
#if move_and_collide(Vector2(0,speed*delta)):
		#if move_and_collide(Vector2(0,speed*delta)).get_collider().name == "PlayerSpaceship":
			#get_tree().change_scene_to_file("res://Scenes/main.tscn")
