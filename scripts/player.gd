extends CharacterBody2D
class_name Player

@onready var sprite_anm = $AnimatedSprite2D

const WALK_SPEED: int = 200
var speed : int = WALK_SPEED
var direction : Vector2 = Vector2.ZERO

var summon_panel: SummoningPanel = null
var summon_panel_open = false

func _ready():
	var summon_panel_p = get_node_or_null("Camera2D/SummonPanel")
	if (summon_panel_p):
		summon_panel = summon_panel_p.get_child(0)
		summon_panel.summon.connect(_on_summon)
		summon_panel.visible = false

func _on_summon(pattern):
	print(str(pattern))

func _input(input: InputEvent):
	if input.is_action_pressed("summon_panel_open_toggle"):
		if (summon_panel):
			summon_panel.visible = not summon_panel.visible
			summon_panel_open = not summon_panel_open
			if (summon_panel_open):
				speed = WALK_SPEED / 2.5
			else:
				speed = WALK_SPEED
	

func _physics_process(delta: float) -> void:
	_play_animation()
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = speed * direction
	if not summon_panel_open:
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
