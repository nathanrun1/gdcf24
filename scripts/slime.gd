extends CharacterBody2D
class_name Slime

@onready var sprite_anm = $AnimatedSprite2D
@onready var player := $"../Player"

const DAMAGE : int = 15
const SPEED : int = 35


func _physics_process(delta: float) -> void:
	_play_animation()
	
	
	var direction : Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = SPEED * direction
	
	if (direction.x > 0): # right facing
		sprite_anm.transform("right")
	else: #left facing
		sprite_anm.transform("left")
	
	
	move_and_collide(velocity * delta)


func _play_animation() -> void:
	sprite_anm.play("default");
