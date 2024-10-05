extends Panel
class_name SummoningPanel

const SUMMON_NODE_CENTER_OFFSET: Vector2 = Vector2(22, 22)

var drawing_line: Line2D
var pattern: Array[int]
@onready var is_drawing: bool = false
@onready var can_draw: bool = true

func _ready():
	_reset_drawing_line()
	for child in $".".get_children():
		if child is SummonNode:
			child.clicked.connect(_on_summon_node_clicked)
			child.hovered.connect(_on_summon_node_hovered)
			
			
func _process(delta: float) -> void:
	if is_drawing:
		drawing_line.set_point_position(drawing_line.get_point_count() - 1, 
			get_global_mouse_position() - self.global_position)
		if not Input.is_mouse_button_pressed(1):
			_finish_drawing()
			

func _on_summon_node_clicked(summon_node: SummonNode) -> void:
	if can_draw and not summon_node.selected:
		is_drawing = true
		_attach_line_to_summon_node(summon_node)
		

func _on_summon_node_hovered(summon_node: SummonNode) -> void:
	if is_drawing and not summon_node.selected:
		_attach_line_to_summon_node(summon_node)


func _finish_drawing() -> void:
	drawing_line.remove_point(drawing_line.get_point_count() - 1)
	is_drawing = false
	can_draw = false
	print(pattern)

func _reset_drawing_line() -> void:
	if drawing_line:
		drawing_line.queue_free()
	drawing_line = Line2D.new()
	drawing_line.antialiased = true
	drawing_line.add_point(Vector2(0,0))
	add_child(drawing_line)

func _attach_line_to_summon_node(summon_node: SummonNode) -> void:
	if not summon_node.selected:
		summon_node.selected = true
		drawing_line.add_point(_get_snode_center_pos(summon_node), drawing_line.get_point_count() - 1)
		pattern.append(summon_node.index)

func _get_snode_center_pos(summon_node: SummonNode) -> Vector2:
	return summon_node.position + SUMMON_NODE_CENTER_OFFSET - drawing_line.position
