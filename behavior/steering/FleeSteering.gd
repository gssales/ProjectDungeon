class_name FleeSteering extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  var entity_velocity = entity._velocity
  var entity_position = entity.get_position()
  var entity_max_speed = entity.max_speed
  var target_position
  if params.has('target') and params.target != null:
    target_position = params.target
  else:
    return Vector3.ZERO
  
  var desired_velocity = (entity_position - target_position).normalized() * entity_max_speed
  return desired_velocity - entity_velocity

