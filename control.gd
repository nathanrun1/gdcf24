extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	var center = get_size() / 2
	var radius = min(get_size().x, get_size().y) / 2
	var color = 	Color(0.5, 0.7, 1)
	
	draw_circle(center, radius, color, true);
