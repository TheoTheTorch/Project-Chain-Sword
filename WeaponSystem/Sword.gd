extends Position2D

# Position Calculations
var direction := Vector2(0,0)
export var length_min : int = 25
export var length_max : int = 150
export var slash_time : float = 0.4
var length : float = length_min
export var length_speed : int = 1480
export var go_back_time : float = 0.2
# Sprite Rotation
export var smooth_speed : float = 16
# States
enum states {IDLE, ATTACK, COOLDOWN}
var state = states.IDLE
var attack_started := false
var cooldown_started := false
# Collision
onready var hitbox = get_node("Hitbox/CollisionPolygon2D")

func _physics_process(delta: float) -> void:
	match state:
		states.IDLE:
			attack_started = false
			if Input.is_action_just_pressed("attack"):
				state = states.ATTACK
			hitbox.disabled = true
		states.ATTACK:
			slash(delta)
			if Input.is_action_just_released("attack") || $SlashTime.time_left == 0:
				cooldown_started = false
				state = states.COOLDOWN
			hitbox.disabled = false
		states.COOLDOWN:
			if cooldown_started == false:
				get_parent().get_node("CoolDown").start()
				cooldown_started = true
			if get_parent().get_node("CoolDown").time_left == 0:
				state = states.IDLE
			hitbox.disabled = true
	rotate(delta)
	position = direction * length


func mouse_dir() -> Vector2:
#	return Vector2(cos(global_rotation), sin(global_rotation))
	return get_parent().global_position.direction_to(get_global_mouse_position()).normalized()


func slash(delta) -> void:
#	if Input.is_action_just_pressed("attack"):
	if attack_started == false:
		length = length_min
		$SlashTime.start()
		attack_started = true
	if Input.is_action_just_released("attack"):
		$TweenBack.interpolate_property(self, "length",
				length, length_min, go_back_time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$TweenBack.start()
	
	if Input.is_action_pressed("attack"):
		if $SlashTime.time_left >= $SlashTime.wait_time / 2 && $SlashTime.time_left != 0:
			length += $SlashTime.time_left * length_speed * delta
		elif $SlashTime.time_left <= $SlashTime.wait_time / 2 && $SlashTime.time_left != 0:
			length -= $SlashTime.time_left * 2 * length_speed * delta
		length = clamp(length, length_min, length_max)
		direction = mouse_dir()

func rotate(delta) -> void:
	global_rotation += get_local_mouse_position().angle() * smooth_speed * delta

