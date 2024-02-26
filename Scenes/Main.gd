extends Node2D



func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")




func _on_exit_button_pressed():
	get_tree().quit()

#TODO: Set up a life system
#TODO: Powerups - Slow time, screen blast,  
#TODO: Upgrade -  Shoot mini meteroites,
#TODO: When shooting smthing or using a one-time powerup, Meteroid spins much faster for 0.1 secs and back to normal
