class_name FollowTargetState extends BaseState

var SeekSteering
var ArriveSteering

var time_before_loosing_interest = 8
var time_elapsed_interest = 0

func _enter(_entity: Entity):
  SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  ArriveSteering = load("res://behavior/steering/ArriveSteering.gd")
  
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 17 })
    
    
func _execute(entity: Entity, delta: float):
  # vá na direção do inimigo
  if entity.distance_to_target < 5:
    emit_signal("change_steering", ArriveSteering.new())
  else:
    emit_signal("change_steering", SeekSteering.new())
    
  # se estiver perto o sufiente vá pro modo ataque
  if entity.distance_to_target <= 2:
    var AttackState = load("res://behavior/states/ally_fsm/AllyAttackState.gd")
    emit_signal("change_state", AttackState.new())
    return
    
  # se estiver há mais de 8 de distance do jogador
    # FollowLeaderState
  if entity.distance_from_leader >= 10:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
    
  
func _exit(_entity: Entity):
  pass
