class_name SummonInterface extends Node2D

@export var summon_panel_p: Control
var summon_panel: SummoningPanel

enum SUMMON_TYPE {SPELL,MONSTER}

const SPELL_PATTERNS = {
	[[0, 1], [1, 2], [2, 4], [4, 6], [6, 7], [7, 8]]: "Freeze"
}

const DIRECTION_PATTERNS = {
	[[0, 7], [2, 7]]: "Down",
	[[2, 3], [3, 8]]: "Left",
	[[1, 6], [1, 8]]: "Up",
	[[0, 5], [5, 6]]: "Right",
	[[1, 8], [3, 8]]: "DownLeft",
	[[1, 6], [5, 6]]: "UpRight",
	[[0, 5], [0, 7]]: "UpLeft",
	[[2, 3], [2, 7]]: "DownRight"
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

signal spell(pattern, direction)
signal monster(pattern, direction)

var cur_sequence = []
var cur_type: SUMMON_TYPE

func _ready() -> void:
	print(summon_panel_p)
	summon_panel = summon_panel_p.get_child(0)
	summon_panel.summon.connect(_on_summon)
	summon_panel.visible = false

func _on_summon(pattern: Array[Array]):
	if SPELL_PATTERNS.get(pattern) and cur_sequence.is_empty():
		cur_sequence.append(SPELL_PATTERNS[pattern])
		cur_type = SUMMON_TYPE.SPELL
	if DIRECTION_PATTERNS.get(pattern) and not cur_sequence.is_empty():
		# Confirm summon after direction given
		cur_sequence.append(DIRECTION_PATTERNS[pattern])
		if cur_type == SUMMON_TYPE.SPELL:
			spell.emit(cur_sequence[0], DIRECTION_ROTATIONS[cur_sequence[1]])
		cur_sequence = []
		

func is_panel_open() -> bool:
	return summon_panel_p.visible and summon_panel.visible
	
func toggle_panel():
	summon_panel.visible = not summon_panel.visible

func reset_panel():
	summon_panel.reset()
