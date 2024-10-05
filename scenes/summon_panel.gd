extends Panel
class_name SummoningPanel

signal summon

const SUMMON_NODE_CENTER_OFFSET: Vector2 = Vector2(22, 22)

var drawing_line: Line2D
@onready var is_drawing: bool = false

func _ready():
	drawing_line = Line2D.new()
	drawing_line.antialiased = true
	drawing_line.add_point(Vector2(0,0))
	add_child(drawing_line)
	for child in $".".get_children():
		if child is SummonNode:
			child.clicked.connect(_on_summon_node_clicked)
			child.hovered.connect(_on_summon_node_hovered)

func _get_snode_center_pos(summon_node: SummonNode) -> Vector2:
	return summon_node.position + SUMMON_NODE_CENTER_OFFSET - drawing_line.position

func _on_summon_node_clicked(summon_node: SummonNode) -> void:
	if not summon_node.selected:
		is_drawing = true
		summon_node.selected = true
		drawing_line.add_point(_get_snode_center_pos(summon_node))
		print("adding point at " + str(_get_snode_center_pos(summon_node)))

func _on_summon_node_hovered(summon_node: SummonNode) -> void:
	if is_drawing and not summon_node.selected:
		summon_node.selected = true
		drawing_line.add_point(_get_snode_center_pos(summon_node), drawing_line.get_point_count() - 1)
		print("adding point at " + str(_get_snode_center_pos(summon_node)))
		
func _process(delta: float) -> void:
	drawing_line.set_point_position(drawing_line.get_point_count() - 1, get_global_mouse_position() - self.global_position)
	
		
	
