class_name AttackState extends BaseState

signal entity_attack

const ATTACK_STATE = "attack_state"

func _enter(_entity: Entity):
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 2 })
    
func _execute(entity: Entity, _delta: float):  
  if not entity.target_on_sight:
    var LookOutState = load("res://behavior/states/LookOutState.gd")
    emit_signal("change_state", LookOutState.new())
    return
  
  if entity.distance_to_target > 5:
    var FollowState = load("res://behavior/states/FollowState.gd")
    emit_signal("change_state", FollowState.new())
    return
  
  if entity.can_attack:
    emit_signal("entity_attack")
