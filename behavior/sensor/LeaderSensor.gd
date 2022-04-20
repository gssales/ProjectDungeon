class_name PartyLeaderSensor extends Sensor

signal leader_position_changed(leader_state)

var leader_position = null
  
func update(_delta: float) -> void:
  pass
  
func _on_PartyManager_leader_position(position):
  leader_position = position
  if leader_position != null:
    var dist = get_position().distance_to(leader_position)
    if dist < 100:
      var intersect = intersect_ray(leader_position)
      if intersect.has("collider") and intersect["collider"].is_in_group('player'):
        emit_signal("leader_position_changed", { "leader_position": leader_position, "leader_on_sight": true })
        return
  emit_signal("leader_position_changed",  { "leader_position": leader_position, "leader_on_sight": false })
