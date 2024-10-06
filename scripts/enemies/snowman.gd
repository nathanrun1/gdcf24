extends Enemy
class_name Snowman

@onready var sprite_anm = $AnimatedSprite2D

@export var Bullet: PackedScene

const SHOOT_FRAME := 15

var shot_damage : int = 10
var top_speed : float = 800
var top_acc : float = 5
var panic_radius : int = 100
var shoot_delay_seconds : int = 0.5
var bullet_speed : int = 550

var acc : Vector2 = Vector2.ZERO

func _ready():
	health = 75
	

func _physics_process(delta: float) -> void:
	_play_animation()
	
	
	var direction : Vector2 = global_position - player.global_position
	var ndirection : Vector2 = direction.normalized()

	
	rotation = atan(direction.x / -direction.y) 
	rotation += PI if direction.y > 0 else 00
	
	if direction.length() <= panic_radius:
		acc = ndirection * top_acc
		velocity += acc
		velocity = velocity.normalized() * min(velocity.length(), top_speed)
	else: 
		velocity = Vector2.ZERO
		
	move_and_collide(velocity * delta)

func _play_animation() -> void:
	sprite_anm.play("shoot");
	if (sprite_anm.frame == SHOOT_FRAME):
		sprite_anm.frame = 0
		var b = Bullet.instantiate()
		$"..".add_child(b)
		b.snowman = self
		b.transform = $Nose.global_transform

func freeze(seconds) -> void:
	# Snowman can't get frozen!!
	pass
