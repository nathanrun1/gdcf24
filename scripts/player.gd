extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D
@onready var health_bar = $HealthBar

const DAMAGE : int = 0

const SPEED : int = 200
var direction : Vector2 = Vector2.ZERO

var health : int = 100
const I_FRAME : int = 30
var i_frame_count = 0

func _physics_process(delta: float) -> void:
	
	_play_animation()
	
	if i_frame_count > 0:
		i_frame_count -= 1
		if i_frame_count == 0:
			$HurtBox/CollisionShape2D.disabled = false
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = SPEED * direction
	
	var overlapping_mobs = $HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 1:
		i_frame_count = I_FRAME
		$HurtBox/CollisionShape2D.disabled = true
	for enemy in overlapping_mobs:
		health -= enemy.DAMAGE
		health_bar.value = health

	
	
	
	move_and_collide(velocity * delta)



func _play_animation() -> void:
	if (direction.x > 0): # right facing
		sprite_anm.transform("right")
	elif (direction.x < 0): #left facing
		sprite_anm.transform("left")
	if (velocity.length() > 0.0):
		sprite_anm.play("move")
	else:
		sprite_anm.play("idle")
