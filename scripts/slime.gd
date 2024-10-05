extends CharacterBody2D

@onready var sprite_anm = $AnimatedSprite2D


@onready var player := $"../Player"

const speed : int = 50;


func _physics_process(delta: float) -> void:
	var direction : Vector2 = global_position.direction_to(player.global_position)
	velocity = speed * direction
	move_and_slide()

func play_default_animation() -> void:
	$AnimatedSprite2D.play("default");
	
