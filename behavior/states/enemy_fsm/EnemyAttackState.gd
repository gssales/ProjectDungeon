class_name EnemyAttackState extends BaseState

signal entity_attack

const ATTACK_STATE = "attack_state"

func _enter(entity: Entity):
  #warning-ignore-all:return_value_discarded
  connect("entity_attack", entity, "_on_AttackState_entity_attack")
  
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  emit_signal("change_steering", SeekSteering.new())
  
  emit_signal("change_entity", { 'max_speed': 2 })
    
    
func _execute(entity: Entity, _delta: float):  
  if not entity.target_on_sight:
    var LookOutState = load("res://behavior/states/enemy_fsm/LookOutState.gd")
    emit_signal("change_state", LookOutState.new())
    return
  
  if entity.distance_to_target > 5:
    var FollowState = load("res://behavior/states/enemy_fsm/FollowState.gd")
    emit_signal("change_state", FollowState.new())
    return
  
  if entity.can_attack:
    emit_signal("entity_attack")


func _exit(entity: Entity):
  disconnect("entity_attack", entity, "_on_AttackState_entity_attack")  
