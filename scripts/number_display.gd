class_name NumberDisplay extends RichTextLabel

@onready var anm = $AnimationPlayer

func _ready() -> void:
	visible = false

func popup(value: String, color: Color):
	print(color)
	text = value
	modulate = color
	visible = true
	anm.play("Rise and Fade")
	await get_tree().create_timer(1).timeout
	queue_free()
