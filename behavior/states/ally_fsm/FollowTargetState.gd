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
  if entity.line_of_sight_state.foe_on_sight:
    emit_signal("change_entity", { 'steering_params_target': entity.line_of_sight_state.foe_position})
    
  # vá na direção do inimigo
  if entity.line_of_sight_state.distance_to_foe < 5:
    emit_signal("change_steering", ArriveSteering.new())
  else:
    emit_signal("change_steering", SeekSteering.new())
    
  # se estiver perto o sufiente vá pro modo ataque
  if entity.line_of_sight_state.distance_to_foe <= 2:
    var AttackState = load("res://behavior/states/ally_fsm/AllyAttackState.gd")
    emit_signal("change_state", AttackState.new())
    return
    
  # se estiver há mais de 42 de distance do jogador
  if entity.leader_state.distance_from_leader >= 42 or not entity.line_of_sight_state.foe_on_sight:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
    
  # se o inimigo for atacar, evade
  if entity.battle_state != null and entity.battle_state.foe_prob_attack > 0.5:
    var DefenseState = load("res://behavior/states/ally_fsm/DefenseState.gd")
    emit_signal("change_state", DefenseState.new())
    return
  
func _exit(_entity: Entity):
  pass
