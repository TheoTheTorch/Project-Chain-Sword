extends Control

export(String) var level1 = ""

func _ready():
	add_to_group("UI")

func switch_scene(button_name:String) -> void:
	match button_name:
# warning-ignore:return_value_discarded
		"Start": get_tree().change_scene(level1)
		"Quit": get_tree().quit()
