extends KinematicBody2D


onready var FollowTargets = $States/FollowTargets

func _physics_process(_delta: float) -> void:
# warning-ignore:return_value_discarded
	move_and_slide(FollowTargets.velocity)


func _on_EnemyHitbox_on_death() -> void:
	queue_free()
