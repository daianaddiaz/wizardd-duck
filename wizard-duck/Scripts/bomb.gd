extends Area2D

@export var bomb: Area2D
@export var explosion_time = 2.0
@export var explosion_radius = 100.0
@export var capa_destructible = 6

signal explosion

func _ready(): 
	add_to_group("egg_bombs")
	$explosion_area/CollisionShape2D.shape.radius = explosion_radius
	await get_tree().create_timer(explosion_time).timeout
	explode()
	queue_free()
	print("bomba explotó")
	#"ARREGLAR ESTO O DEJARLO RARO COMO ESTABA ANTES"
	
func explode():
	var explosion_area = $explosion_area
	var bodies = explosion_area.get_overlapping_bodies()
	for body in bodies:
		var distance = global_position.distance_to(body.global_position)
		# Solo hacer daño si está dentro del radio real
		if distance <= explosion_radius:
			print("¡Daño a ", body.name, "!")
			emit_signal("explosion")
		else:
			print(body.name, " está demasiado lejos (", distance, " px)")
		
#func tile_destroy(tilemap, pos):
	## Verificar todas las layers
	#for layer in tilemap.get_layers_count():
		#var data = tilemap.get_cell_tile_data(layer, pos)
		#if data and data.get_custom_data("destructible"):
			#tilemap.set_cell(layer, pos, -1)
		   
		
	
	
