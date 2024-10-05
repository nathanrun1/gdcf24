extends CharacterBody2D
class_name coilbra

@onready var sprite_anm = $AnimatedSprite2D
@onready var player := $"../Player"
@onready var collision_frame = $CollisionShape2D

const TOP_SPEED : float = 800
const TOP_ACC : float = 20
const TOP_JERK : float = 0.5


var acc : Vector2 
var jerk: Vector2

var stagger : bool = false
var prime: bool = true
const STAGGER_TIME : int = 1
var stagger_timer : float

var player_pos_at_charge : Vector2
var direction: Vector2


func _physics_process(delta: float) -> void:
	_play_animation()
	if stagger: 
		stagger_timer -= delta
		if stagger_timer > 0:
			return
		else: 
			stagger = false
			prime = true
		
	if prime:
		player_pos_at_charge = player.global_position
		direction = global_position.direction_to(player_pos_at_charge).normalized()
		prime = false
	
	
	jerk = direction * TOP_JERK
	acc += jerk
	velocity += acc
	velocity = velocity.normalized() * min(velocity.length(), TOP_SPEED)

	
	if ((player_pos_at_charge - position).length() < velocity.length() * delta):
		stagger = true
		stagger_timer = STAGGER_TIME
		velocity = Vector2.ZERO
		acc = Vector2.ZERO

	
	move_and_collide(velocity * delta)


func _play_animation() -> void:
	sprite_anm.play("default");


func _charge(direction: Vector2) -> void:
	pass
