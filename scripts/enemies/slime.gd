extends Enemy
class_name Slime

@onready var sprite_anm = $AnimatedSprite2D

var damage : int = 15
var speed : int = 35
var attack_delay_seconds : float = 0.5
var attack_delay_count : float = 0

func _ready():
	health = 75
	value = 50


func _physics_process(delta: float) -> void:
	_play_animation()
	
	var direction : Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = speed * direction
	if is_frozen:
		velocity = speed * direction * 0.1
	
	if (direction.x > 0): # right facing
		sprite_anm.transform("right")
	else: #left facing
		sprite_anm.transform("left")
		
	if attack_delay_count > 0:
		attack_delay_count -= delta
	
	var collider = move_and_collide(velocity * delta)
	if collider:
		if (collider.get_collider() == player) and attack_delay_count <= 0:
			attack_delay_count = attack_delay_seconds
			damage_player(damage)


func _play_animation() -> void:
	sprite_anm.play("default");
