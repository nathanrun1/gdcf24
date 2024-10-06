class_name Enemy 
extends CharacterBody2D

var DAMAGE : int
var SPEED : int

@onready var sprite_anm = $AnimatedSprite2D
@onready var player = $Player
@onready var hitbox = $Hitbox


func _play_animation():
	pass



func _init():
	pass

	
