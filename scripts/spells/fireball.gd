class_name FireBallSpell extends Area2D

#DEBUG
#func _input(input: InputEvent):
	#if input.is_action_pressed("summon_panel_open_toggle") and $CPUParticles2D.emitting == false:
		#execute()
var is_executing := false

func execute():
	is_executing = true;
	
	

func _physics_process(delta: float) -> void:

	
	if is_executing:
		
		position.x += 1
		print("fire ball executing")
		for body in get_overlapping_bodies():
			print(body)
			if body is Enemy:
				print(body)
				# todo: change this to enemy damage
				body.take_damage(10)
