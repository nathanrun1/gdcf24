class_name FireBallSpell extends Area2D

#DEBUG
#func _input(input: InputEvent):
	#if input.is_action_pressed("summon_panel_open_toggle") and $CPUParticles2D.emitting == false:
		#execute()
var is_executing := false

func execute():
	$CPUParticles2D.emitting = true
	is_executing = true
	await get_tree().create_timer(1.5).timeout
	is_executing = false
	queue_free()

func _physics_process(delta: float) -> void:
	if is_executing:
		print("fire ball executing")
		for body in get_overlapping_bodies():
			print(body)
			if body is Enemy:
				print(body)
				# todo: change this to enemy damage
				#body.freeze(2)
