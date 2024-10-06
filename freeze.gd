class_name FreezeSpell extends Area2D

#DEBUG
#func _input(input: InputEvent):
	#if input.is_action_pressed("summon_panel_open_toggle") and $CPUParticles2D.emitting == false:
		#execute()
		

func execute():
	$CPUParticles2D.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
