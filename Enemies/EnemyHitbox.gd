extends Area2D

export var max_health : int = 100
onready var health := max_health
export var defense : int = 1
var is_invincible := false


func _on_EnemyHitbox_area_entered(_area: Area2D) -> void:
	if not is_invincible:
		get_parent().get_node("Sprite/AnimationPlayer").play("Hurt")
		decrease_health(get_node("/root/PlayerDamage").player_dmg)
		
		is_invincible = true
		$InvincibilityTime.start()

func decrease_health(dmg) -> void:
	health -= max(dmg - defense, 1)
	if health < 0:
		get_parent().queue_free()


func _on_InvincibilityTime_timeout() -> void:
	is_invincible = false
