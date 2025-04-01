extends Node2D
signal score_changed

func _ready():
	set_objects()
	$spawn/player.reset($spawn.position)

func set_camera_limits():
	var map_size = $TileMapLayer.get_used_rect()
	var cell_size = $TileMapLayer.tile_set.tile_size
	$player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func set_objects():
	var cells = $TileMapLayer.get_used_cells()
	for cell in cells:
		var data = $TileMapLayer.get_cell_tile_data(cell)
		if data.get_custom_data("special") == "scorebox":
			var scorebox = load("res://scorebox.tscn").instantiate()
			add_child(scorebox)
			scorebox.position = $TileMapLayer.map_to_local(cell)
			$TileMapLayer.erase_cell(cell)
		elif data.get_custom_data("special") == "brick":
			var brick = load("res://brick.tscn").instantiate()
			add_child(brick)
			brick.position = $TileMapLayer.map_to_local(cell)
			$TileMapLayer.erase_cell(cell)
		elif data.get_custom_data("special") == "enemy":
			var enemy = load("res://enemy.tscn").instantiate()
			add_child(enemy)
			enemy.position = $TileMapLayer.map_to_local(cell)
			$TileMapLayer.erase_cell(cell)

func _on_finish_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file.bind("res://win.tscn").call_deferred()
