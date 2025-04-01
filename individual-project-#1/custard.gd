extends Control

func _input(event):
	if event.is_action_pressed("start"):
		get_tree().change_scene_to_file.bind("res://level.tscn").call_deferred()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file.bind("res://level.tscn").call_deferred()
