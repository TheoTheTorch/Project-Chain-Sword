extends Node


export var max_health : int = 100
onready var health := max_health
export var defense : int = 1
var is_invincible := false

enum types {PLAYER, ENEMY, ENEMY_ATTACK, PLAYER_ATTACK}
export(types) var type = types.ENEMY

signal on_death

func take_damage(dmg, _name) -> void:
	if _name == type:
		health -= max(dmg - defense, 1)
		if health < 0: emit_signal("on_death")

func update_invincibility(value) -> void:
	is_invincible = value

func _on_Health_area_entered(area: Area2D) -> void:
	match type:
			types.PLAYER:
				if area.type == types.ENEMY_ATTACK: pass
			types.ENEMY:
				if area.type == types.PLAYER_ATTACK: pass
			types.ENEMY_ATTACK: pass
			types.PLAYER_ATTACK: pass
