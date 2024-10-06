extends Enemy
class_name coilbra

@onready var sprite_anm = $AnimatedSprite2D
@onready var collision_frame = $CollisionShape2D
@onready var Hurtbox = $Hurtbox

var top_speed : float = 800
var top_acc : float = 20
var top_jerk : float = 0.5

var charge_damage : int = 30

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
	
	
	jerk = direction * top_jerk
	acc += jerk
	velocity += acc
	velocity = velocity.normalized() * min(velocity.length(), top_speed)

	var collider = move_and_collide(velocity * delta)
	
	if collider:
		stagger = true
		stagger_timer = STAGGER_TIME
		velocity = Vector2.ZERO
		acc = Vector2.ZERO
		if (collider.get_collider() == player):
			damage_player(charge_damage)

	#var collisions = Hurtbox.get_overlapping_bodies()
	#
	#if collisions.size() > 1 or (snapped(position.x, 0.01) == snapped(past_pos.x, 0.01)\
	#and snapped(position.y, 0.01) == snapped(past_pos.y, 0.01)): # Colliding or hasn't moved
		#stagger = true
		#stagger_timer = STAGGER_TIME
		#velocity = Vector2.ZERO
		#acc = Vector2.ZERO

	


func _play_animation() -> void:
	sprite_anm.play("default");


func _charge(direction: Vector2) -> void:
	pass
