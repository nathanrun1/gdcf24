## Insert hitbox and then check
class_name EnemySpawnChecker extends Area2D

var valid: bool = true
var active: bool = false
var spawning_enemy: Enemy = null

func activate(position: Vector2) -> void:
	if spawning_enemy != null and not self.get_children().is_empty():
		self.transform = spawning_enemy.transform
		self.position = position
		active = true

func _physics_process(delta: float) -> void:
	if active:
		for body in get_overlapping_bodies():
			if not body == spawning_enemy and (body.is_in_group("enemies") or body.is_in_group("obstacles")):
				valid = false
				return
		valid = true
