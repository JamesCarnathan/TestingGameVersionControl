extends StaticBody2D

@onready var StartPosition = $Start.global_position.x
@onready var EndPosition = $End.global_position.x
var direction : float
@export var speed : float

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

	if position.x >= max(StartPosition, EndPosition):
		position.x = max(StartPosition, EndPosition)
		direction = -1
	elif position.x <= min(StartPosition, EndPosition):
		position.x = min(StartPosition, EndPosition)
		direction = 1
