extends TileMapLayer

@onready var player = $"../../Player"

func _process(_delta):
	if player != null:
		var player_global_position: Vector2 = player.global_position
		var player_tile_coords: Vector2i = local_to_map(to_local(player_global_position))
		var tile_data = get_cell_tile_data(player_tile_coords)
		
		if tile_data != null:
			var tipo = tile_data.get_custom_data("recolectables")
			
			match tipo:
				"jump":
					player.active_double_jump = true
					set_cell(player_tile_coords, -1, Vector2i(-1, -1), -1)
					print("desbloqueo del duble jump")
				"dash":
					player.active_dash = true
					set_cell(player_tile_coords, -1, Vector2i(-1, -1), -1)
					print("desbloqueo del dash")
				
		
