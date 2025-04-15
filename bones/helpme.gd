extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("pawnch")
	else:
		$AnimationPlayer.play("idle")
	
		
