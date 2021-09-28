extends Node2D

export var speed : int = 500
var velocity := Vector2(0,0)
var intention := Vector2(0,0)
export(int) var max_intention: int = 80
export(int) var max_speed := 160
export(int) var acceleration := 240
export(int) var target_distance := 20
export(int) var hazard_distance := 60
# To not jam up with other enemies:
#var bodies : Array = []

export var Enemy_path : NodePath
onready var Enemy = get_node(Enemy_path)
onready var Player = get_node("/root").find_node("Player", true, false)

signal update_position

#func _ready() -> void:
#	get_enemies()
#
#func get_enemies() -> void:
#	bodies = []
#	for enemy in get_tree().get_nodes_in_group("Enemy"):
#		if not enemy in bodies && not enemy == Enemy: 
#			bodies.append(enemy)


func _physics_process(delta: float) -> void:
	#Affecting intentions
	if Player != null:
		push_towards_player()
#	for body in bodies:
#		push_away_from_objects(body)
		# Actual moving
	velocity = intention * acceleration * delta
	velocity = velocity.clamped(max_speed)
	emit_signal("update_position", velocity)


func push_towards_player() -> void:
	var player_pos = Player.global_position
	var player_distance = Enemy.global_position.distance_to(player_pos)
	var player_dir = (player_pos - Enemy.global_position).normalized()
	
	var string_force = (player_distance - target_distance)
	intention += string_force * player_dir
	intention = intention.clamped(max_intention)


#func push_away_from_objects(body) -> void: # Currently isn't working for some reason
#	var body_pos = body.global_position
#	var body_distance = Enemy.global_position.distance_to(body_pos)
#	var body_dir = (body_pos - Enemy.global_position).normalized()
#
#	var string_force = (hazard_distance - body_distance) 
#	intention -= string_force * body_dir
#	intention = intention.clamped(max_intention)
