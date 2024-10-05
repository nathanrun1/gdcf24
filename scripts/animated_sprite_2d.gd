extends AnimatedSprite2D

func transform(direction: String):
	if (direction == "left"):
		self.flip_h = 0
	elif (direction == "right"):
		self.flip_h = 1
