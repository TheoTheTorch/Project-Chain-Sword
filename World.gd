extends YSort


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if $Enemies.get_child_count() == 0:
		$WeaponHandle/Camera2D/Label.visible = true
