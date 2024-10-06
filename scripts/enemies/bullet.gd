class_name Bullet extends Area2D

var speed = 250
var snowman: Snowman = null

func _ready():
	body_entered.connect(_on_Bullet_body_entered)

func _physics_process(delta: float):
	if snowman:
		position += transform.y * snowman.bullet_speed * delta
	else:
		position += transform.y * speed * delta

func _on_Bullet_body_entered(body):
	if not body.is_in_group("enemies"):
		if body == snowman.player:
			snowman.damage_player(snowman.shot_damage)
		queue_free()
		
