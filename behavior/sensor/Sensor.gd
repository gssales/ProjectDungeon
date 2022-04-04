class_name Sensor extends Spatial

func get_position() -> Vector3:
  return global_transform.origin

func intersect_ray(target: Vector3):
  return get_world().direct_space_state.intersect_ray(get_position(), target)
  
func update(_delta: float) -> void:
  pass
