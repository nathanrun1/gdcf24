class_name SummonInterface extends Node2D

@export var summon_panel_p: Control
@export var DEBUG: bool = false
var summon_panel: SummoningPanel

enum SUMMON_TYPE {SPELL,ENEMY}

@export var player: Player
@export_category("Enemies")
@export var slime_scene: PackedScene
@export var snowman_scene: PackedScene
@export var charger_scene: PackedScene
@export_category("Other")
@export var smoke_entry_scene: PackedScene

const ENEMY_SUMMON_OFFSET = 50

const SPELL_PATTERNS = {
	[[0, 1], [1, 2], [2, 4], [4, 6], [6, 7], [7, 8]]: "Freeze",
	[[0, 1], [0, 5], [1, 2], [5, 6]]: "Fireball"
}

const ENEMY_PATTERNS = {
	[[0, 1], [1, 4], [4, 5], [4, 8], [5, 8]]: "Charger",
	[[0, 3], [0, 5], [2, 3], [2, 5], [3, 4], [3, 6], [4, 5], [5, 8]]: "Snowman",
	[[0, 1], [0, 3], [1, 2], [2, 4], [3, 6], [4, 6], [6, 7], [7, 8]]: "Slime"
}

@onready var enemy_scenes = {
	"Charger": charger_scene,
	"Slime": slime_scene,
	"Snowman": snowman_scene
}

const DIRECTION_PATTERNS = {
	[[0, 7], [2, 7]]: "Down",
	[[2, 3], [3, 8]]: "Left",
	[[1, 6], [1, 8]]: "Up",
	[[0, 5], [5, 6]]: "Right",
	[[1, 8], [3, 8]]: "DownRight",
	[[1, 6], [5, 6]]: "DownLeft",
	[[0, 5], [0, 7]]: "UpLeft",
	[[2, 3], [2, 7]]: "UpRight"
}

const DIRECTION_ROTATIONS = {
	"Up": -90,
	"Right": 0,
	"Down": 90,
	"Left": 180,
	"UpLeft": -135,
	"UpRight": -45,
	"DownRight": 45,
	"DownLeft": 135
}

const DIRECTION_VECTORS = {
	"Up": Vector2(0, -1),
	"Right": Vector2(1, 0),
	"Down": Vector2(0, 1),
	"Left": Vector2(-1, 0),
	"UpLeft": Vector2(-1, -1),
	"UpRight": Vector2(1, -1),
	"DownRight": Vector2(1, 1),
	"DownLeft": Vector2(-1, 1)
}

signal spell(pattern, direction)
signal monster(pattern, direction)

var cur_sequence = []
var cur_type: SUMMON_TYPE

func _ready() -> void:
	print(summon_panel_p)
	summon_panel = summon_panel_p.get_child(0)
	summon_panel.summon.connect(_on_summon)
	summon_panel.visible = false

func _input(input: InputEvent) -> void:
	if DEBUG:
		if input.is_action_pressed("Debug_Summon_Charger"):
			_summon_enemy("Charger", "Left")
		if input.is_action_pressed("Debug_Summon_Snowman"):
			_summon_enemy("Snowman", "Left")
		if input.is_action_pressed("Debug_Summon_Slime"):
			_summon_enemy("Slime", "Left")
		if input.is_action_pressed("Debug_Freeze"):
			spell.emit("Freeze", 0)

func _on_summon(pattern: Array[Array]):
	if SPELL_PATTERNS.get(pattern) and cur_sequence.is_empty():
		cur_sequence.append(SPELL_PATTERNS[pattern])
		cur_type = SUMMON_TYPE.SPELL
		$"../correct_pattern_sound".play()
	elif DIRECTION_PATTERNS.get(pattern) and not cur_sequence.is_empty():
		# Confirm summon after direction given
		cur_sequence.append(DIRECTION_PATTERNS[pattern])
		if cur_type == SUMMON_TYPE.SPELL:
			spell.emit(cur_sequence[0], DIRECTION_ROTATIONS[cur_sequence[1]])
		if cur_type == SUMMON_TYPE.ENEMY:
			_summon_enemy(cur_sequence[0], cur_sequence[1])
		cur_sequence = []
		$"../correct_pattern_sound".play()
	elif ENEMY_PATTERNS.get(pattern) and cur_sequence.is_empty():
		var enemy_type: String = ENEMY_PATTERNS[pattern]
		var amnt: int = randi_range(1, 4)
		_summon_enemy(enemy_type, "Up")
		if amnt > 1:
			_summon_enemy(enemy_type, "Right")
		if amnt > 2:
			_summon_enemy(enemy_type, "Left")
		if amnt > 3:
			_summon_enemy(enemy_type, "Down")
		$"../correct_pattern_sound".play()
	else:
		$"../incorrect_pattern_sound".play()
		
		

func _summon_enemy(enemy_type: String, direction: String):
	var enemy_scene = enemy_scenes[enemy_type]
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	
	var dir_vector = DIRECTION_VECTORS[direction]
	var occupied_check := EnemySpawnChecker.new()
	occupied_check.spawning_enemy = enemy
	$"..".add_child(occupied_check)
	
	var hitbox_copy = enemy.get_child(0).duplicate()
	occupied_check.add_child(hitbox_copy)
	occupied_check.activate(player.global_position + (dir_vector * ENEMY_SUMMON_OFFSET))
	await get_tree().create_timer(0.05).timeout
	if not occupied_check.valid:
		enemy.queue_free()
		# ADD INVALID SPAWN ANIMATION HERE
	else:
		$"..".add_child(enemy)
		enemy.position = player.global_position + (dir_vector * ENEMY_SUMMON_OFFSET)
		var smoke_entry = smoke_entry_scene.instantiate()
		enemy.add_child(smoke_entry)
		if enemy is Slime:
			smoke_entry.position = Vector2(0, -10)
		if enemy is Snowman:
			smoke_entry.position = Vector2(2, -18)
		if enemy is Coilbra:
			smoke_entry.position = Vector2(1, -17)
		print(smoke_entry)
		print(smoke_entry.transform)
		print(smoke_entry.global_position)
		smoke_entry.play('smoke')
		
			
	


func is_panel_open() -> bool:
	return summon_panel_p.visible and summon_panel.visible
	
func toggle_panel():
	summon_panel.visible = not summon_panel.visible

func reset_panel():
	summon_panel.reset()
