extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D
const SPEED = 100

func _physics_process(delta: float) -> void:

	var directionx := Input.get_axis("ui_left", "ui_right")
	if directionx:	
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	
	move_and_slide()
	
	if (velocity.length() > 0.0):
		sprite_anm.play("move")
	else:
		sprite_anm.play("idle")
	
