extends Enemy
class_name Coilbra

@onready var sprite_anm = $AnimatedSprite2D

var top_speed : float = 800
var top_acc : float = 100
var top_jerk : float = 0.5

var charge_damage : int = 100

var acc : Vector2 
var jerk: Vector2

var stagger : bool = false
var prime: bool = true
const STAGGER_TIME : int = 1
var stagger_timer : float

var player_pos_at_charge : Vector2
var direction: Vector2

var past_pos : Vector2 

var is_charging: bool = false

func _ready():
	health = 150

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
	
	
	jerk = direction * top_jerk
	if is_frozen:
		jerk *= 0.1
	acc += jerk
	acc = min(acc.length(), top_acc) * acc.normalized()
	velocity += acc
	velocity = min(velocity.length(), top_speed) * velocity.normalized()
	if is_frozen:
		velocity *= 0.1
	var face_direction = global_position.direction_to(player.global_position).normalized()
	if (face_direction.x > 0):
		sprite_anm.flip_h = true
	else:
		sprite_anm.flip_h = false

	var collider = move_and_collide(velocity * delta)
	if collider:
		stagger = true
		stagger_timer = STAGGER_TIME
		var strength = acc.length() / top_acc
		velocity = Vector2.ZERO
		acc = Vector2.ZERO
		if (collider.get_collider() == player):
			damage_player(charge_damage * strength)

	#var collisions = Hurtbox.get_overlapping_bodies()
	#
	#if collisions.size() > 1 or (snapped(position.x, 0.01) == snapped(past_pos.x, 0.01)\
	#and snapped(position.y, 0.01) == snapped(past_pos.y, 0.01)): # Colliding or hasn't moved
		#stagger = true
		#stagger_timer = STAGGER_TIME
		#velocity = Vector2.ZERO
		#acc = Vector2.ZERO

	


func _play_animation() -> void:
	if stagger:
		sprite_anm.play("Idle")
	else:
		sprite_anm.play("Roll")
