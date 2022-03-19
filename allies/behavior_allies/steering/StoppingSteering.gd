class_name StoppingSteering_Ally extends BaseSteeringBehavior_Ally

func _behavior_type():
  return "stopping"
  
func _calculate(entity: Ally, delta: float, params):
  var velocity: Vector3 = -entity._velocity * 1.5
  if velocity.length() > entity.max_speed:
    velocity = velocity.normalized() * entity.max_speed
  return velocity
