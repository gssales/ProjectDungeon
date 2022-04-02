class_name ArriveSteering_Ally extends BaseSteeringBehavior_Ally

func _calculate(entity: Ally, _delta: float, params):
  var to_target = params.target - entity.transform.origin
  var distance = to_target.length()
  
  if distance > 1:
    var speed = distance / 0.9
    speed = min(speed, entity.max_speed)
    
    var desired_velocity = to_target * speed / distance
    return desired_velocity - entity._velocity
  
  return Vector3.ZERO
