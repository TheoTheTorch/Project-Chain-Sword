extends KinematicBody2D

# MOVEMENT varaiables
var velocity := Vector2(0,0)
export var max_speed : int = 360
export var acceleration : int = 2160
export var deceleration : int = 2840
export var turning_speed : int = 8400
# DASH varaiables
enum dash_types {MOVEMENT, MOUSE}
export(dash_types) var dash_type = dash_types.MOVEMENT
export var dash_speed : int = 640
export var dash_time : float = 0.002
var can_dash := true
var has_dash_started := false
# STATE varaiables
enum states {IDLE, RUN, DASH, DEAD}
onready var state = states.IDLE


signal update_invincibility

# STATES
func _physics_process(delta: float) -> void:
	match state:
		states.IDLE:
			if movement_input() != Vector2(0,0): state = states.RUN
			elif dash_input() && can_dash: state = states.DASH
		states.RUN:
			base_movement(delta)
			if velocity == Vector2(0,0): state = states.IDLE
			elif dash_input() && can_dash:state = states.DASH
		states.DASH:
			dash(delta)
			if velocity == Vector2(0,0):
				has_dash_started = false
				state = states.IDLE
	velocity = move_and_slide(velocity)


# INPUT
func movement_input() -> Vector2:
	var input := Vector2(0,0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input

func dash_input() -> Vector2:
	match dash_type:
		dash_types.MOVEMENT:
			if Input.is_action_pressed("dash"):
				return movement_input()
		dash_types.MOUSE:
			if Input.is_mouse_button_pressed(2):
				return global_position.direction_to(get_global_mouse_position())
	return Vector2(0,0)


# CALCULATIONS
func base_movement(delta) -> void:
	if movement_input() != Vector2(0,0):
		if movement_input() == velocity.sign(): # velocity and direction matches
			velocity += movement_input().normalized() * acceleration * delta
		else: # velocity and direction doesnt match
			velocity += movement_input().normalized() * turning_speed * delta
		velocity = velocity.clamped(max_speed)
	else: 
		velocity = velocity.move_toward(Vector2(0,0), deceleration * delta)


# DASH ---------------------------------------------------
func dash(delta) -> void:
	
	if has_dash_started == false:
		############################
		$InvinciblilityTime.start()
		emit_signal("update_invincibility", true)
		$Sprite/Hexagon.color = Color(1,1,1,1)
		############################
		
		var dir : Vector2 = dash_input()
		velocity = dir.normalized() * dash_speed
		
		$DashTime.start()
		has_dash_started = true
	
	if can_dash == false:
		velocity = velocity.move_toward(Vector2(0,0), deceleration * 2.5 * delta)

func _on_Dash_tween_completed(_object: Object, _key: NodePath) -> void:
	can_dash = false
	$DashReload.start()

func _on_DashReload_timeout() -> void:
	can_dash = true

func _on_InvinciblilityTime_timeout() -> void:
	emit_signal("update_invincibility", false)
	$Sprite/Hexagon.color = Color(0.709804, 0.094118, 0.094118, 1)

func _on_DashTime_timeout() -> void:
	can_dash = false
	$DashReload.start()
# DASH ---------------------------------------------------



func _on_CollisionHealth_on_death() -> void:
	state = states.DEAD
	$Sprite/Hexagon2.color = Color(1,1,1)
