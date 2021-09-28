extends KinematicBody2D



func _on_FollowPlayer_update_position(velocity) -> void:
	velocity = move_and_slide(velocity)



func _on_EnemyHitbox_on_death() -> void:
	queue_free()
