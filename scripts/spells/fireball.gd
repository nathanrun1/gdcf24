class_name FireBallSpell extends Area2D

#DEBUG
#func _input(input: InputEvent):
	#if input.is_action_pressed("summon_panel_open_toggle") and $CPUParticles2D.emitting == false:
		#execute()
var is_executing := false

func execute():
	is_executing = true;
	await get_tree().create_timer(3).timeout
	queue_free()

var collided = []
	

func _physics_process(delta: float) -> void:
	if is_executing:
		position += transform.x * 10
		for body in get_overlapping_bodies():
			if not body in collided:
				collided.append(body)
				if body is Enemy:
					body.take_damage(45)
				if collided.size() >= 3 or body.is_in_group("obstacles"):
					queue_free()
