class_name Altar extends Sprite2D

const PANEL_POS: Vector2 = Vector2(-288, -163.015)
const PANEL_SCALE: Vector2 = Vector2(0.495, 0.495)

@export var player: CharacterBody2D
@export var summon_panel: Control
@onready var summon_panel_i: SummoningPanel = summon_panel.get_child(0)

signal summon(altar: Altar, pattern: Array[int])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	summon_panel_i.drawing_complete.connect(_on_drawing_complete)

func _on_drawing_complete(pattern):
	summon.emit(self, pattern)

func _on_body_entered(body):
	if (body == player):
		summon_panel.visible = true
		summon_panel_i.reset()

func _on_body_exited(body):
	if (body == player):
		summon_panel.visible = false
	
