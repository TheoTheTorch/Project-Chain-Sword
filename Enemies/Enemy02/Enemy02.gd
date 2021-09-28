extends KinematicBody2D

onready var Player := get_node("/root").find_node("Player", true, false)
export var attack_range : int = 300

enum {IDLE, ATTACK_START, ATTACK}
var state = IDLE
var is_attacking := false
var can_attack := true

func _process(delta: float) -> void:
	var Player_distance : float = global_position.distance_to(Player.global_position)
	match state:
		ATTACK_START:
			$States/HomingAttack.attack()
	transitions(Player_distance)

func transitions(Player_distance:  float) -> void:
	match state:
		IDLE:
			if $States/CanAttackTime.time_left == 0 && can_attack == false:
				$States/CanAttackTime.start()
			if Player_distance <= attack_range && can_attack:
				state = ATTACK_START
		ATTACK_START:
			is_attacking = true
			can_attack = false
			state = ATTACK
		ATTACK:
			if not is_attacking:
				state = IDLE


func _on_HomingAttack_on_attack_completion() -> void:
	is_attacking = false
func _on_CanAttackTime_timeout() -> void:
	can_attack = true
func _on_EnemyHitbox_on_death() -> void:
	queue_free()


