extends Position2D

export var spawn_time : float = 4
export var max_enemy_count : int = 100
export var enemy_name := "res://Enemies/Enemy03/Enemy03.tscn"
onready var enemy = load(enemy_name)

func _ready() -> void:
	$Timer.start(rand_range(0.8 , 1.2))

func _on_Timer_timeout() -> void:
	if not len(get_tree().get_nodes_in_group("Enemy")) >= max_enemy_count:
		var enemy_inst = enemy.instance()
		enemy_inst.global_position = global_position
		get_parent().add_child(enemy_inst)
		$Timer.start(rand_range(spawn_time-0.2 , spawn_time+0.2))
