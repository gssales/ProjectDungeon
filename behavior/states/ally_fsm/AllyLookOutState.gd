class_name AllyLookOutState extends BaseState

signal entity_rotate(radians)

const LOOKOUT_STATE = "lookout_state"

var rng = RandomNumberGenerator.new()

var lookout_duration
var time_until_rotate
var time_elapsed = 0
var timer_rotate = 0

func _enter(entity: Entity):
  #warning-ignore-all:return_value_discarded
  connect("entity_rotate", entity, "_on_LookOutState_entity_rotate")
  
  rng.randomize()
  
  var StoppingSteering = load("res://behavior/steering/StoppingSteering.gd")
  emit_signal("change_steering", StoppingSteering.new())
  emit_signal("change_entity", { 'max_speed': 20 })
  
  lookout_duration = rng.randf_range(6, 8)
  time_until_rotate = rng.randf_range(2, 5)
  
  
func _execute(entity: Entity, delta: float):
  if entity._velocity.length() > 0.05:
    return
  entity._velocity = Vector3.ZERO
  
  # Olha ao redor por x segundos
  time_elapsed += delta
  timer_rotate += delta
  
  if timer_rotate >= time_until_rotate:
    timer_rotate = 0
    var rot = rand_range(-PI/3, PI/3)
    rot += PI/6 * rot/abs(rot)
    emit_signal("entity_rotate", rot)
    time_until_rotate = rng.randf_range(2, 5)
  
  # se estiver há mais de 8 de distance do jogador
  if entity.distance_from_leader >= 8:
    var FollowLeaderState = load("res://behavior/states/ally_fsm/FollowLeaderState.gd")
    emit_signal("change_state", FollowLeaderState.new())
    return
  
  # se ver um inimigo
  if entity.target_on_sight:
    var FollowTargetState = load("res://behavior/states/ally_fsm/FollowTargetState.gd")
    emit_signal("change_state", FollowTargetState.new())
    return
  
  # depois de x segundos muda de estado
  if time_elapsed >= lookout_duration:
    var AllyWanderState = load("res://behavior/states/ally_fsm/AllyWanderState.gd")
    emit_signal("change_state", AllyWanderState.new())
    return


func _exit(entity: Entity):
  disconnect("entity_rotate", entity, "_on_LookOutState_entity_rotate")
