class_name SeekSteering extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  var desired_velocity = (params.target - entity.transform.origin).normalized() * entity.max_speed
  return desired_velocity - entity._velocity
