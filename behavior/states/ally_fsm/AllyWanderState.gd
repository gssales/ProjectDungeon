class_name AllyWanderState extends BaseState

var wandering_duration
var time_elapsed = 0

func _enter(_entity: Entity):
  var WanderSteering = load("res://behavior/steering/WanderSteering.gd")
  emit_signal("change_steering", WanderSteering.new())
  emit_signal("change_entity", { 'max_speed': 5 })
  wandering_duration = rand_range(3, 5)

func _execute(entity: Entity, delta: float):
  # vaga aleatoriamente por X segundos
  time_elapsed += delta
  
  # se estiver há mais de 8 de distance do jogador
  if entity.distance_from_leader >= 6:#24:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
  
  # se ver um inimigo
  if entity.target_on_sight:
    var FollowTargetState = load("res://behavior/states/ally_fsm/FollowTargetState.gd")
    emit_signal("change_state", FollowTargetState.new())
    return
  
  # depois de x segundos muda de estado
  if time_elapsed >= wandering_duration:
    var AllyLookOutState = load("res://behavior/states/ally_fsm/AllyLookOutState.gd")
    emit_signal("change_state", AllyLookOutState.new())
    return


func _exit(_entity: Entity):
  pass
