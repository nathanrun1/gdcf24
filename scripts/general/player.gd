extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D
@onready var health_bar = $HealthBar


signal zero_health
signal player_damage(damage: int)

const WALK_SPEED: int = 200
var speed : int = WALK_SPEED
var direction : Vector2 = Vector2.ZERO


var health : int = 100
var queued_damage : int = 0
var damage_queued: bool = false
const I_FRAME_SECONDS : float = 0.1
var i_frame_count: float = 0

# Spells
var freeze_spell_scene = preload("res://scenes/freeze.tscn")
var fireball_spell_scene = preload("res://scenes/fireball.tscn")

@export var summon_interface: SummonInterface

func _ready():
	summon_interface.spell.connect(_on_spell)
	health_bar.value = health
	player_damage.connect(_on_player_damage)

func _on_spell(spellname, direction):
	if spellname == "Freeze":
		var new_freeze = freeze_spell_scene.instantiate()
		add_child(new_freeze)
		new_freeze.rotation_degrees = direction
		new_freeze.execute()
	if spellname == "Fireball":
		for i in range(3):
			var new_fireball = fireball_spell_scene.instantiate()
			$"..".add_child(new_fireball)
			$Muzzle.rotation_degrees = direction - 15 + (i * 15)
			new_fireball.transform = $Muzzle.global_transform
			new_fireball.execute()
		

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
	
func _on_player_damage(damage: int):
	if (i_frame_count <= 0 and not damage_queued):
		queued_damage += damage
		damage_queued = true

func _physics_process(delta: float) -> void:
	if health <= 0:
		$Camera2D/DeathPanel.visible = true
		return
	_play_animation()
	direction = Input.get_vector("player_left", "player_right", "player_up", "player_down").normalized()
	# -- Movement & Collisions --
	velocity = speed * direction
	move_and_collide(velocity * delta)
	# -- Enemy Interaction --
	if i_frame_count > 0:
		$AnimatedSprite2D.modulate = Color.CRIMSON
		if not damage_queued:
			queued_damage = 0
		i_frame_count -= delta
	else:
		$AnimatedSprite2D.modulate = Color.WHITE
	if damage_queued:
		i_frame_count = I_FRAME_SECONDS
		health -= queued_damage
		queued_damage = 0
		damage_queued = false
		health_bar.value = health
		if (health <= 0):
			zero_health.emit()
	# OLD SYSTEM --
	#var overlapping_mobs = $HurtBox.get_overlapping_bodies()
	#if overlapping_mobs.size() > 0:
		#i_frame_count = I_FRAME
		#$HurtBox/CollisionShape2D.disabled = true
		#$AnimatedSprite2D.modulate = Color.CRIMSON
	#for enemy in overlapping_mobs:
		#health -= enemy.DAMAGE
		#health_bar.value = health
		#if (health <= 0):
			#zero_health.emit()
	# --
	# -- Player direction --
	if not summon_interface.is_panel_open():
		# Summoning panel is not open
		if (direction.x > 0): # right facing
			sprite_anm.transform("right")
		elif (direction.x < 0): # left facing
			sprite_anm.transform("left")
	else:
		# Summoning panel is open
		if (direction.x > 0): # left facing
			sprite_anm.transform("left")
		elif (direction.x < 0): # right facing
			sprite_anm.transform("right")



func _play_animation() -> void:
	if health > 0:
		if (velocity.length() > 0.0):
			sprite_anm.play("move")
		else:
			sprite_anm.play("idle")
	else:
		sprite_anm.stop()
