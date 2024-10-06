class_name SmokeEntry extends AnimatedSprite2D

func run():
	play("smoke")
	print("run")

func _process(delta: float) -> void:
	print(frame)
	if frame == 5:
		await get_tree().create_timer(1/16).timeout
		queue_free()
