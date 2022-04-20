class_name WanderState extends BaseState

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
  
  # se ver um inimigo, vai pro modo seguir
  if entity.line_of_sight_state.foe_on_sight:
    var FollowState = load("res://behavior/states/enemy_fsm/FollowState.gd")
    emit_signal("change_state", FollowState.new())
  
  # senao muda para o modo lookout
  if time_elapsed >= wandering_duration:
    var LookOutState = load("res://behavior/states/enemy_fsm/LookOutState.gd")
    emit_signal("change_state", LookOutState.new())


func _exit(_entity: Entity):
  pass
