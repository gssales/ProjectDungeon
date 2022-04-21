class_name FollowLeaderState extends BaseState

func _enter(_entity: Entity):
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 15 })
  
func _execute(entity: Entity, _delta: float):
  if entity.leader_state.leader_on_sight:
    emit_signal("change_entity", { 'steering_params_target': entity.leader_state.leader_position})
  else:
    var FindPathState = load("res://behavior/states/ally_fsm/FindPathState.gd")
    emit_signal("change_state", FindPathState.new())
    return
  
  # se estiver há menos de 4 de distance do jogador
  if entity.leader_state.distance_from_leader <= 16:
    var AllyWanderState = load("res://behavior/states/ally_fsm/AllyWanderState.gd")
    emit_signal("change_state", AllyWanderState.new())
    return
  
func _exit(_entity: Entity):
  pass
