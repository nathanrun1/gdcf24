class_name Enemy extends CharacterBody2D

var is_frozen = false
var health: int = 100
var value: int = 100
var is_dead = false

@onready var player := $"../Player"
@onready var health_bar: ProgressBar = $HealthBar
@onready var score_interface: ScoreInterface = $"../ScoreInterface"

@export var number_popup_scene: PackedScene

func damage_player(damage: int):
	if not is_dead:
		player.player_damage.emit(damage)

func freeze(seconds: float) -> void:
	if not is_frozen:
		$AnimatedSprite2D.modulate = Color.LIGHT_BLUE
		is_frozen = true
		take_damage(50)
		await get_tree().create_timer(seconds).timeout
		is_frozen = false
		$AnimatedSprite2D.modulate = Color.WHITE
	
func take_damage(damage: int):
	health -= damage
	health_bar.value = health
	var prev_color = self.modulate
	self.modulate = Color.CRIMSON
	await get_tree().create_timer(0.1).timeout
	self.modulate = prev_color
	if (health <= 0):
		_death()

func _death():
	self.modulate = Color.DARK_GRAY
	score_interface.add_score(value)
	var num_popup = number_popup_scene.instantiate()
	add_child(num_popup)
	num_popup.position = Vector2(0, 0)
	num_popup.popup("+" + str(value), Color.RED)
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
	
