extends Node


export var max_health : int = 100
onready var health : int = max_health
export var defense : int = 1
var is_invincible := false

enum types {PLAYER, ENEMY, ENEMY_ATTACK, PLAYER_ATTACK}
export(types) var type = types.ENEMY

signal on_death
signal took_tamage

func take_damage(dmg) -> void:
# warning-ignore:narrowing_conversion
	health -= max(dmg - defense, 1)
	if health < 0: emit_signal("on_death")
	else: emit_signal("took_tamage")

func _on_Health_area_entered(area: Area2D) -> void:
	if "Enemy" in area.get_groups():
		take_damage(25)


func _on_Player_update_invincibility(value: bool) -> void:
	is_invincible = value
