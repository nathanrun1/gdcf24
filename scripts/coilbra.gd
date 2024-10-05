extends CharacterBody2D

@onready var sprite_anm = $AnimatedSprite2D
@onready var player := $"../Player"

const SPEED : int = 80
const STAGGER_TIME : int = 4


func _physics_process(delta: float) -> void:	
	_play_animation()
	
	
	var direction : Vector2 = global_position.direction_to(player.global_position)
	velocity = SPEED * direction
	
	
	move_and_collide(velocity * delta)


func _play_animation() -> void:
	sprite_anm.play("default");
	
