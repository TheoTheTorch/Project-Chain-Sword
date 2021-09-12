extends Position2D

# Position Calculations
var direction := Vector2(0,0)
export var length_min : int = 25
export var length_max : int = 150
export var slash_time : float = 0.4
var length : float = length_min
export var length_speed : float = 1480
# Sprite Rotation
export var smooth_speed : float = 16


func _physics_process(delta: float) -> void:
	slash(delta)
	global_rotation += get_local_mouse_position().angle() * smooth_speed * delta


func mouse_dir() -> Vector2:
#	return Vector2(cos(global_rotation), sin(global_rotation))
	return get_parent().global_position.direction_to(get_global_mouse_position()).normalized()


func slash(delta) -> void:
	if Input.is_action_just_pressed("attack"):
		length = length_min
		$SlashTime.start()
	if Input.is_action_just_released("attack"):
		length = length_min
		position = direction * length
	
	
	if Input.is_action_pressed("attack"):
		if $SlashTime.time_left >= $SlashTime.wait_time / 2 && $SlashTime.time_left != 0:
			length += $SlashTime.time_left * length_speed * delta
		elif $SlashTime.time_left <= $SlashTime.wait_time / 2 && $SlashTime.time_left != 0:
			length -= $SlashTime.time_left * 2 * length_speed * delta
		length = clamp(length, length_min, length_max)
		direction = mouse_dir()
		position = direction * length


