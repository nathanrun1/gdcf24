extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D
const SPEED = 100

func _physics_process(delta: float) -> void:

	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	var direction = Vector2(directionx, directiony)	
	velocity = direction * SPEED
	if direction.x:
		if direction.x > 0:
			sprite_anm.flip_h = true
		else:
			sprite_anm.flip_h = false
	
	move_and_slide()
	
	if (velocity.length() > 0.0):
		sprite_anm.play("move")
	else:
		sprite_anm.play("idle")
	
