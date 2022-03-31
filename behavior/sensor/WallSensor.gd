class_name WallSensor extends Sensor

signal wall_detected(wall_detection)

var whiskers = [
  Vector3.FORWARD + Vector3.RIGHT,
  Vector3.FORWARD *2,
  Vector3.FORWARD + Vector3.LEFT
 ]

func update(_delta: float) -> void:
  var closest_wall = 1e10
  var wall_normal = Vector3.ZERO
  var contact_length = 0
  
  for whisker in whiskers:
    var intersect = intersect_ray(to_global(whisker))
    if intersect.has("collider") and intersect["collider"].is_in_group("wall"):
      var contact = intersect["position"]
      if get_position().distance_squared_to(contact) < closest_wall:
        closest_wall = get_position().distance_squared_to(contact)
        wall_normal = intersect["normal"]
        contact_length = whisker.distance_to(contact) / whisker.length()
  
  if contact_length > 0:
    emit_signal("wall_detected", {
      'normal': wall_normal, 
      'length': contact_length
      })
  else:
    emit_signal("wall_detected", null)
    
