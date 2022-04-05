class_name FollowLeaderState extends BaseState

func _enter(_entity: Entity):
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 15, 'go_to_leader': true })
  
func _execute(entity: Entity, _delta: float):
  # se estiver há menos de 4 de distance do jogador
  if entity.distance_from_leader <= 16:
    var AllyWanderState = load("res://behavior/states/ally_fsm/AllyWanderState.gd")
    emit_signal("change_state", AllyWanderState.new())
    return
  
func _exit(_entity: Entity):
  emit_signal("change_entity", { 'go_to_leader': false })
