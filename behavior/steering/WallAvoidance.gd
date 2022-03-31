class_name WallAvoidance extends BaseSteeringBehavior

func _calculate(entity: Entity, _delta: float, params):
  if not (params.has("wall_detection") and params["wall_detection"] != null):
    return Vector3.ZERO
  var max_speed = entity.max_speed
  var wall_normal = params["wall_detection"].normal
  var contact_length = params["wall_detection"].length
  
  return wall_normal * max_speed * contact_length;
