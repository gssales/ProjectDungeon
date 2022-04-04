class_name ArriveSteering extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  var to_target = params.target - entity.get_position()
  var distance = to_target.length()
  
  if distance > 1:
    var speed = distance / 0.9
    speed = min(speed, entity.max_speed)
    
    var desired_velocity = to_target * speed / distance
    return desired_velocity - entity._velocity
  
  return Vector3.ZERO
