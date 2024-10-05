extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D

const SPEED : int = 200
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	_play_animation()
	
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	velocity = SPEED * direction
	
	if (direction.x > 0): # right facing
		sprite_anm.transform("right")
	elif (direction.x < 0): #left facing
		sprite_anm.transform("left")
	
	
	move_and_collide(velocity * delta)
	
	


func _play_animation() -> void:
	if (velocity.length() > 0.0):
		sprite_anm.play("move")
	else:
		sprite_anm.play("idle")
