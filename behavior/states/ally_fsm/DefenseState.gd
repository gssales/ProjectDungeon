class_name DefenseState extends BaseState


func _enter(entity: Entity):
  var FleeSteering = load("res://behavior/steering/FleeSteering.gd")
  emit_signal("change_steering", FleeSteering.new())
  emit_signal("change_entity", { 'max_speed': 2, 'offset_heading': PI })

func _execute(entity: Entity, _delta: float):
  # se o inimigo estiver vulnerável
  if entity.battle_state != null and entity.battle_state.foe_prob_attack < 0.5:
    var AttackState = load("res://behavior/states/ally_fsm/AllyAttackState.gd")
    emit_signal("change_state", AttackState.new())
    return

func _exit(entity: Entity):
  emit_signal("change_entity", { 'offset_heading': 0 })
  
