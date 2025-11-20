extends Node2D

@export var Item_area: Area2D
	
signal collect_item_jump

func _ready() -> void:
	Item_area.body_entered.connect(_on_body_entered)


func _on_body_entered(_body):
		emit_signal("collect_item_jump")
		queue_free()
		print("ITEM: activar doble salto")
	
