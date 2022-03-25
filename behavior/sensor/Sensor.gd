class_name Sensor extends Spatial

signal entity_entered(entity)
signal entity_exited(entity)
signal update_closest_entity(entity)

var seen_entities := []

func update(_delta: float) -> void:
  pass
