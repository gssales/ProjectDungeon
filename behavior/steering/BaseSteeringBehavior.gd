class_name BaseSteeringBehavior extends Object

func _behavior_type():
  return "base"
  
func _calculate(entity: Enemy, delta: float, params):
  return Vector3.ZERO
