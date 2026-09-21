extends Camera2D

@onready var player = $"../Player"

func _process(_delta):
	position.x = player.position.x
