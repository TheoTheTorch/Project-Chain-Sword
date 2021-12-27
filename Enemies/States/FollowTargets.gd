extends Node2D

var velocity := Vector2(0,0)


export var acceleration : int = 430
export var max_speed : int = 2600
export var deceleration : int = 1290

export var attract_range : int = 8000
export var attract_power : float = 4.5
export var avoid_range : int = 300
export var avoid_power : float = 1.5

export var desired_distance : int = 160 # From Target


export var number_of_rays: int = 18
export var ray_offset : int = 16
export var ray_length : int = 200
var rays = []

export var target_group := "Target" 
export var exclude_self : NodePath

func _ready() -> void:
	generate_rays()

func _physics_process(delta: float) -> void:
	update_velocity(delta)

func update_velocity(_delta) -> void:
	if combined_desires().length() != 0 && round(closest_target().distance_to(global_position)) > desired_distance:
		velocity += acceleration * combined_desires().normalized()
		velocity = velocity.clamped(max_speed)
	else:
		velocity = Vector2(0,0)
		velocity = velocity.move_toward(Vector2(0,0), deceleration)



# RAYS ------------------------------------------
func generate_rays() -> void:
	for i in range(1, number_of_rays + 1):
		var degrees : float = (360 / float(number_of_rays)) * i
		var ray = RayCast2D.new()
		
		ray.rotation = deg2rad(int(round(degrees)))
		ray.position = Vector2(0, ray_offset).rotated(deg2rad(degrees))
		ray.cast_to.y = ray_length
		ray.enabled = true
		ray.add_exception(get_node(exclude_self))
		
		add_child(ray)
		rays.append(ray)
# RAYS ------------------------------------------

# POSITIONS -------------------------------------
func get_target_positions() -> Array:
	var targets = []
	for target in get_tree().get_nodes_in_group(target_group):
			if global_position.distance_to(target.global_position) <= attract_range:
				#local positions
				targets.append(target.global_position - global_position)
	return targets

func closest_target() -> Vector2:
	var closest_target := Vector2(0,0)
	if get_target_positions() != []:
		closest_target = get_target_positions()[0]
		for pos in get_target_positions():
			if pos.length() < closest_target.length(): closest_target = pos
	return closest_target

func get_avoid_positions() -> Array:
	var targets = []
	for ray in rays:
		if ray.is_colliding():
			targets.append(ray.get_collision_point() - global_position)
	return targets
# POSITIONS -------------------------------------

# DESIRES -------------------------
func attract_desire()  -> Vector2:
	# ATTRACT
	var desire = Vector2(0,0)
	for pos in get_target_positions():
		var strength = (1 / ((pos.length() * pos.length() * pos.length()) + 1)) * attract_power
		desire += pos.normalized() * strength
	return desire

func avoid_desire()  -> Vector2:
	# AVOID
	var desire = Vector2(0,0)
	for pos in get_avoid_positions():
		var strength = 1 / ((pos.length() * pos.length() * pos.length()) + 1) * avoid_power
		desire -= pos.normalized() * strength
	return desire

func combined_desires() -> Vector2:
	return attract_desire() + avoid_desire()
# DESIRES -------------------------
