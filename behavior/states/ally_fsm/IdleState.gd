class_name IdleState extends BaseState

# Change this state to make ally immortal and wait to be added to a party

func _enter(_entity: Entity):
  # entity.is_immortal = true
  pass

func _execute(entity: Entity, _delta: float):
  # se adicionado a party do jogador vaga entorno do jogador
  if entity.added_to_party:
    var AllyWanderState = load("res://behavior/states/ally_fsm/AllyWanderState.gd")
    emit_signal("change_state", AllyWanderState.new())

func _exit(_entity: Entity):
  # entity.is_immortal = false
  pass
