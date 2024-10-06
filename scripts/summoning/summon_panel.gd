extends Panel
class_name SummoningPanel

const SUMMON_NODE_CENTER_OFFSET: Vector2 = Vector2(22, 22)
const SUMMON_NODE_SELECTOR_OFFSET: Vector2 = Vector2(-5, -5)
const DEBUG = true

enum MODE {MOUSE,DIRECTION,KEYPAD}

var drawing_line: Line2D
var pattern: Array[int]
var summon_nodes: Array[SummonNode]
var node_grid: Array[Array] = [[], [], []]
var links: Array[Array]
var overlap_links = {
	[0, 2]: 1,
	[2, 8]: 5,
	[6, 8]: 7,
	[0, 6]: 3,
	[0, 8]: 4,
	[2, 6]: 4,
	[3, 5]: 4,
	[1, 7]: 4
}
@onready var is_drawing: bool = false
@onready var can_draw: bool = true

@export_category("DEBUG")
@export var summon_node_selector: TextureRect
@export var mode: MODE = MODE.KEYPAD
var selected_node: SummonNode

signal summon(pattern: Array[int])

## Resets the summoning panel for reuse
func reset():
	_reset_drawing_line()
	selected_node = summon_nodes[4]
	is_drawing = false
	can_draw = true
	pattern = []
	links = []
	if mode in [MODE.DIRECTION]:
		summon_node_selector.visible = true
	else:
		summon_node_selector.visible = false
	for child in $".".get_children():
		if child is SummonNode:
			child.selected = false
	

func _ready():
	for child in $".".get_children():
		if child is SummonNode:
			child.clicked.connect(_on_summon_node_clicked)
			child.hovered.connect(_on_summon_node_hovered)
			summon_nodes.append(child)
			node_grid[child.grid_pos.x + 1].append(child)
	reset()

func _process(delta: float) -> void:
	if is_drawing:
		if mode == MODE.MOUSE:
			var mouse_pos = (get_global_mouse_position() - drawing_line.global_position) * (1 / $"..".scale.x)
			drawing_line.set_point_position(drawing_line.get_point_count() - 1, 
				mouse_pos)
				
			if not Input.is_mouse_button_pressed(1):
				_finish_drawing()
	if mode == MODE.DIRECTION:
		var direction: Vector2
		direction.x = Input.get_axis("summon_left", "summon_right")
		direction.y = Input.get_axis("summon_up", "summon_down")
		_select_summon_node(node_grid[direction.x + 1][direction.y + 1])

func _input(input: InputEvent):
	if input.is_action_pressed("summon_panel_attach"):
		_attach_line_to_summon_node(selected_node)
	elif input.is_action_pressed("summon_panel_confirm"):
		_finish_drawing()
	if (mode == MODE.KEYPAD):
		if input.is_action_pressed("summon_keypad_1"):
			_attach_line_to_summon_node(summon_nodes[0])
		if input.is_action_pressed("summon_keypad_2"):
			_attach_line_to_summon_node(summon_nodes[1])
		if input.is_action_pressed("summon_keypad_3"):
			_attach_line_to_summon_node(summon_nodes[2])
		if input.is_action_pressed("summon_keypad_4"):
			_attach_line_to_summon_node(summon_nodes[3])
		if input.is_action_pressed("summon_keypad_5"):
			_attach_line_to_summon_node(summon_nodes[4])
		if input.is_action_pressed("summon_keypad_6"):
			_attach_line_to_summon_node(summon_nodes[5])
		if input.is_action_pressed("summon_keypad_7"):
			_attach_line_to_summon_node(summon_nodes[6])
		if input.is_action_pressed("summon_keypad_8"):
			_attach_line_to_summon_node(summon_nodes[7])
		if input.is_action_pressed("summon_keypad_9"):
			_attach_line_to_summon_node(summon_nodes[8])
	
func _select_summon_node(summon_node):
	summon_node_selector.visible = true
	summon_node_selector.position = summon_node.position + SUMMON_NODE_SELECTOR_OFFSET
	selected_node = summon_node
	

func _on_summon_node_clicked(summon_node: SummonNode) -> void:
	if mode != MODE.MOUSE:
		return
	if can_draw and not summon_node.selected:
		is_drawing = true
		_attach_line_to_summon_node(summon_node)
		

func _on_summon_node_hovered(summon_node: SummonNode) -> void:
	if mode != MODE.MOUSE:
		return
	if is_drawing and not summon_node.selected:
		_attach_line_to_summon_node(summon_node)


func _finish_drawing() -> void:
	if $"..".visible and self.visible:
		print("check")
		if mode == MODE.MOUSE:
			drawing_line.remove_point(drawing_line.get_point_count() - 1)
		is_drawing = false
		can_draw = false
		links.sort()
		summon.emit(links)
		if DEBUG:
			print(links)
		reset()

func _reset_drawing_line() -> void:
	if drawing_line:
		drawing_line.queue_free()
	drawing_line = Line2D.new()
	drawing_line.antialiased = true
	if mode == MODE.MOUSE:
		drawing_line.add_point(Vector2(0,0))
	add_child(drawing_line)

func _attach_line_to_summon_node(summon_node: SummonNode) -> void:
	var cur_link
	var cur_link_extr
	if pattern:
		if pattern[pattern.size() - 1] > summon_node.index:
			cur_link = [summon_node.index, pattern[pattern.size() - 1]]
		elif pattern[pattern.size() - 1] < summon_node.index:
			cur_link = [pattern[pattern.size() - 1], summon_node.index]
		else:
			return
	if (cur_link in overlap_links):
		var mid: int = overlap_links[cur_link]
		var temp: int = cur_link[1]
		cur_link = [cur_link[0], mid]
		cur_link_extr = [mid, temp]
	# 
	if (not cur_link in links) and (not cur_link_extr in links):
		if mode == MODE.MOUSE:
			drawing_line.add_point(_get_snode_center_pos(summon_node), drawing_line.get_point_count() - 1)
		else:
			drawing_line.add_point(_get_snode_center_pos(summon_node), drawing_line.get_point_count())
		links.append(cur_link)
		if (cur_link_extr != null):
			pattern.append(cur_link_extr[0])
			links.append(cur_link_extr)
		pattern.append(summon_node.index)
		if mode == MODE.KEYPAD:
			_select_summon_node(summon_node)

func _get_snode_center_pos(summon_node: SummonNode) -> Vector2:
	return summon_node.position + SUMMON_NODE_CENTER_OFFSET - drawing_line.position
