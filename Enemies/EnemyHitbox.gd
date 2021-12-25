extends Area2D

export var max_health : int = 100
onready var health := max_health
export var defense : int = 1
var is_invincible := false

signal on_death

func _on_EnemyHitbox_area_entered(_area: Area2D) -> void:
	if not is_invincible:
		get_parent().get_node("Sprite/AnimationPlayer").play("Hurt")
		
		var dmg = get_node("/root/PlayerDamage").player_dmg
		decrease_health(dmg)
		
		is_invincible = true
		$InvincibilityTime.start()

func decrease_health(dmg) -> void:
# warning-ignore:narrowing_conversion
	health -= max(dmg - defense, 1)
	if health < 0:
		emit_signal("on_death")


func _on_InvincibilityTime_timeout() -> void:
	is_invincible = false
