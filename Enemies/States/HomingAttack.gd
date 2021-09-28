extends Node2D


export var Enemy_path : NodePath
export var overshoot : int = 80
export var attack_time : float = 0.4

onready var Player := get_node("/root").find_node("Player", true, false)
onready var Enemy = get_node(Enemy_path)

signal on_attack_completion

func attack() -> void:
	if Player != null:
		var goal_pos : Vector2 = global_position.direction_to(Player.global_position) * (overshoot + global_position.distance_to(Player.global_position))
		$Tween.interpolate_property(Enemy, "global_position", Enemy.global_position, goal_pos, attack_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	emit_signal("on_attack_completion")
