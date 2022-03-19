class_name SeekSteering_Ally extends BaseSteeringBehavior_Ally

func _calculate(entity: Ally, _delta: float, params):
  var desired_velocity = (params.target - entity.transform.origin).normalized() * entity.max_speed
  return desired_velocity - entity._velocity
