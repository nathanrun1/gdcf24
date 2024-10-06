extends CharacterBody2D
class_name Snowman

@onready var sprite_anm = $AnimatedSprite2D
@onready var player := $"../Player"

const DAMAGE : int = 10
const TOP_SPEED : float = 800
const TOP_ACC : float = 5
const PANIC_RADIUS : int = 100

var acc : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_play_animation()
	
	
	var direction : Vector2 = global_position - player.global_position
	var ndirection : Vector2 = direction.normalized()

	
	rotation = atan(direction.x / -direction.y) 
	rotation += PI if direction.y > 0 else 00
	
	print(direction.length())
	if direction.length() <= PANIC_RADIUS:
		acc = ndirection * TOP_ACC
		velocity += acc
		velocity = velocity.normalized() * min(velocity.length(), TOP_SPEED)
	else: 
		velocity = Vector2.ZERO
		
	move_and_collide(velocity * delta)

func _play_animation() -> void:
	sprite_anm.play("shoot");
