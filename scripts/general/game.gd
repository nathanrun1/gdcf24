extends Node2D

@onready var player = $Player

func _process(delta: float):
	if Input.is_anything_pressed():
		
		var summon_direction : Vector2 = (Vector2.ZERO - player.direction) * 100
		if player.direction == Vector2.ZERO:
			summon_direction = Vector2(-50, 0)
		
		
		#if Input.is_action_just_pressed("summon_slime"):
			#var summoned_slime = preload("res://scenes/slime.tscn").instantiate()
			#summoned_slime.position = player.global_position + summon_direction
			#add_child(summoned_slime)
		#if Input.is_action_just_pressed("summon_coilbra"):
			#var summoned_coilbra = preload("res://scenes/coilbra.tscn").instantiate()
			#summoned_coilbra.position = player.global_position + summon_direction
			#add_child(summoned_coilbra)
