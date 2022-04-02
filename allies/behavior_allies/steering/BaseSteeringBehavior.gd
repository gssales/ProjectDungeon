class_name BaseSteeringBehavior_Ally extends Object

func _behavior_type():
  return "base"
  
func _calculate(entity: Ally, delta: float, params):
  return Vector3.ZERO
