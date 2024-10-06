class_name ScoreInterface extends Node2D

var score: int = 0
@export var score_label: RichTextLabel

func add_score(amount: int):
	score += amount
	score_label.text = "SCORE: " + str(score)
