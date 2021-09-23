extends Position2D

export var move_time : float = 0.2
export var node_path : NodePath

func _physics_process(_delta: float) -> void:
	move()

func move():
	$TweenPos.interpolate_property(self, "position", position, get_node(node_path).global_position,
			move_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$TweenPos.start()
