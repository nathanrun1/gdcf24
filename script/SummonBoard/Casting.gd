extends Node2D


@onready var line := $cast_line



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.set_point_position(0, Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line.set_point_position(1, get_local_mouse_position())
