extends Button


func _process(delta: float) -> void:
	if (button_pressed):
		_on_click()

func _on_click():
	get_tree().reload_current_scene()
