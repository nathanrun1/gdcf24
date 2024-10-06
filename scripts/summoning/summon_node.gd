extends TextureRect
class_name SummonNode


var selected = false
@export var index: int = -1
@export var grid_pos: Vector2 = Vector2(-1, -1)

signal clicked(summon_node: SummonNode)
signal hovered(summon_node: SummonNode)

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
			return

func _on_mouse_entered():
	hovered.emit(self)
	

	
