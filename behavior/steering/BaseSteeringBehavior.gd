class_name BaseSteeringBehavior extends Object

func _behavior_type():
  return "base"
  
func _calculate(_entity: Entity, _delta: float, _params):
  return Vector3.ZERO
