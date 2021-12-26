extends Node2D


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
