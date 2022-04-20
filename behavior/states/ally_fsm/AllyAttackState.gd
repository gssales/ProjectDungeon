class_name AllyAttackState extends BaseState

signal entity_attack

const ATTACK_STATE = "attack_state"

func _enter(entity: Entity):
  #warning-ignore-all:return_value_discarded
  connect("entity_attack", entity, "_on_AttackState_entity_attack")  
  
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 2 })
    
func _execute(entity: Entity, _delta: float):
  if entity.line_of_sight_state.foe_on_sight:
    emit_signal("change_entity", { 'steering_params_target': entity.line_of_sight_state.foe_position})
  
  # se estiver há mais de 42 de distance do jogador
  if entity.leader_state.distance_from_leader >= 42 or not entity.line_of_sight_state.foe_on_sight:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
    
  # se estiver há mais de 5 de distance do inimigo
  if entity.line_of_sight_state.distance_to_foe > 5:
    var FollowTargetState = load("res://behavior/states/ally_fsm/FollowTargetState.gd")
    emit_signal("change_state", FollowTargetState.new())
    return
    
  # se o inimigo for atacar, evade
  if entity.battle_state != null and entity.battle_state.foe_prob_attack > 0.5:
    var DefenseState = load("res://behavior/states/ally_fsm/DefenseState.gd")
    emit_signal("change_state", DefenseState.new())
    return
  
  
  if entity.can_attack:
    emit_signal("entity_attack")


func _exit(entity: Entity):
  disconnect("entity_attack", entity, "_on_AttackState_entity_attack")  
