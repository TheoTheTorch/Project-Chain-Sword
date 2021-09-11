extends Area2D



func _on_EnemyHitbox_body_entered(body: Node) -> void:
	get_tree().call_group("Player", "collided_with_enemy", get_parent().damage)
