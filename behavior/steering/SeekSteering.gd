class_name SeekSteering extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  var entity_velocity = entity._velocity
  var entity_position = entity.get_position()
  var entity_max_speed = entity.max_speed
  var target_position = params.target
  
  var desired_velocity = (target_position - entity_position).normalized() * entity_max_speed
  return desired_velocity - entity_velocity

