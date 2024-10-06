extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D

const WALK_SPEED: int = 200
var speed : int = WALK_SPEED
var direction : Vector2 = Vector2.ZERO

# Spells
var freeze_spell_scene = preload("res://scenes/freeze.tscn")

@export var summon_interface: SummonInterface

func _ready():
	summon_interface.spell.connect(_on_spell)

func _on_spell(spellname, direction):
	if spellname == "Freeze":
		var new_freeze = freeze_spell_scene.instantiate()
		add_child(new_freeze)
		new_freeze.rotation_degrees = direction
		new_freeze.execute()
		print(direction)
		

func _input(input: InputEvent):
	if input.is_action_pressed("summon_panel_open_toggle"):
		summon_interface.toggle_panel()
		if (summon_interface.is_panel_open()):
			summon_interface.reset_panel()
			speed = WALK_SPEED / 2.5
			sprite_anm.speed_scale = 0.6
		else:
			speed = WALK_SPEED
			sprite_anm.speed_scale = 1
	

func _physics_process(delta: float) -> void:
	_play_animation()
	direction = Input.get_vector("player_left", "player_right", "player_up", "player_down").normalized()
	velocity = speed * direction
	if not summon_interface.is_panel_open():
		# Summoning panel is not open
		if (direction.x > 0): # right facing
			sprite_anm.transform("right")
		elif (direction.x < 0): #left facing
			sprite_anm.transform("left")
	else:
		# Summoning panel is open
		if (direction.x > 0): # right facing
			sprite_anm.transform("left")
		elif (direction.x < 0): #left facing
			sprite_anm.transform("right")
	move_and_collide(velocity * delta)

func _play_animation() -> void:
	if (velocity.length() > 0.0):
		sprite_anm.play("move")
	else:
		sprite_anm.play("idle")
