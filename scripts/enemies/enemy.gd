class_name Enemy extends CharacterBody2D

@onready var player := $"../Player"
var is_frozen = false
var health: int = 100

func damage_player(damage: int):
	player.player_damage.emit(damage)

func freeze(seconds: float) -> void:
	if not is_frozen:
		$AnimatedSprite2D.modulate = Color.LIGHT_BLUE
		is_frozen = true
		await get_tree().create_timer(seconds).timeout
		is_frozen = false
		$AnimatedSprite2D.modulate = Color.WHITE
	
	
