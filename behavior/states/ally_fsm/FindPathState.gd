class_name FindPathState extends BaseState

func _enter(_entity: Entity):
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 15 })
  
func _execute(entity: Entity, _delta: float):
  if not entity.leader_state.leader_on_sight:
    var next_point = entity.astar.next_in_path_toward(entity.get_position(), entity.leader_state.leader_position)
    emit_signal("change_entity", { 'steering_params_target': next_point})
  else:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
  
func _exit(_entity: Entity):
  pass
