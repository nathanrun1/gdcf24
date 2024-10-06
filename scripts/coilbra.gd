extends CharacterBody2D
class_name coilbra

signal damage_player

@onready var sprite_anm = $AnimatedSprite2D
@onready var player := $"../Player"
@onready var collision_frame = $CollisionShape2D
@onready var Hurtbox = $Hurtbox

const TOP_SPEED : float = 800
const TOP_ACC : float = 20
const TOP_JERK : float = 0.5

const DAMAGE : int = 30

var acc : Vector2 
var jerk: Vector2

var stagger : bool = false
var prime: bool = true
const STAGGER_TIME : int = 1
var stagger_timer : float

var player_pos_at_charge : Vector2
var direction: Vector2

var past_pos : Vector2 

func _physics_process(delta: float) -> void:
	_play_animation()
	
	past_pos = position
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

	move_and_collide(velocity * delta)

	var collisions = Hurtbox.get_overlapping_bodies()
	for node in collisions:
		if player == node:
			damage_player.emit()
	
	if collisions.size() > 1 or (snapped(position.x, 0.01) == snapped(past_pos.x, 0.01) and snapped(position.y, 0.01) == snapped(past_pos.y, 0.01)):
		stagger = true
		stagger_timer = STAGGER_TIME
		velocity = Vector2.ZERO
		acc = Vector2.ZERO

	


func _play_animation() -> void:
	sprite_anm.play("default");


func _charge(direction: Vector2) -> void:
	pass
