extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Chest")
	if(body.is_in_group("Player")):
		body.damage(2)
