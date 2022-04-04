class_name WallAvoidance extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  if not (params.has("wall_detected") and params["wall_detected"] != null):
    return Vector3.ZERO
  var max_speed = entity.max_speed
  var wall_normal = params["wall_detected"].normal
  var contact_length = params["wall_detected"].length
  
  return wall_normal * max_speed * contact_length;
