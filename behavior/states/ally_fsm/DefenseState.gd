class_name DefenseState extends BaseState


func _enter(_entity: Entity):
  var FleeSteering = load("res://behavior/steering/FleeSteering.gd")
  emit_signal("change_steering", FleeSteering.new())
  emit_signal("change_entity", { 'max_speed': 4, 'offset_heading': PI })

func _execute(entity: Entity, _delta: float):
  
  # se estiver há mais de 42 de distance do jogador
  if entity.leader_state.distance_from_leader >= 42 or not entity.line_of_sight_state.foe_on_sight:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
    
  # se o inimigo estiver vulnerável
  if entity.battle_state != null and entity.battle_state.foe_prob_attack < 0.5:
    var AttackState = load("res://behavior/states/ally_fsm/AllyAttackState.gd")
    emit_signal("change_state", AttackState.new())
    return

func _exit(_entity: Entity):
  emit_signal("change_entity", { 'offset_heading': 0 })
  
