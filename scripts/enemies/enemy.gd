class_name Enemy extends CharacterBody2D

@onready var player := $"../Player"

func damage_player(damage: int):
	player.player_damage.emit(damage)
