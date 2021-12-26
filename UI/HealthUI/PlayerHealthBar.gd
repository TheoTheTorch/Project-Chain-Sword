extends Control


onready var max_value = get_node("/root/PlayerStats").max_health
onready var current = max_value

func _ready() -> void:
	$ProgressBar.max_value = max_value

func set_value(new_value) -> void:
	$ProgressBar.value = new_value
