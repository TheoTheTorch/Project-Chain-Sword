extends Button

func _ready() -> void:
	randomize()

func _on_Button_pressed():
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
		$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	get_tree().call_group("UI", "switch_scene", name)
