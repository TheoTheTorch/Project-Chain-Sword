extends KinematicBody2D



func _on_FollowPlayer_update_position(velocity) -> void:
	velocity = move_and_slide(velocity)
