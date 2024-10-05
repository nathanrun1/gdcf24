extends TextureRect
class_name SummonNode


var selected = false

signal clicked(pos)
signal hovered(pos)	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
	elif event is InputEventMouseMotion:
		hovered.emit(self)

	
