class_name Behavior extends Node

onready var WanderState = preload("res://behavior/states/WanderState.gd")

var current_state: BaseState

func _ready():
  _on_BehaviorState_change_state(WanderState.new())
  
func update(delta):
  current_state._execute(get_parent(), delta)

func _on_BehaviorState_change_state(new_state: BaseState) -> void:
  if current_state != null:
    current_state._exit(get_parent())
    current_state.disconnect("change_state", self, "_on_BehaviorState_change_state")
    current_state.disconnect("change_entity", get_parent(), "_on_BehaviorState_change_entity")
    current_state.disconnect("change_steering", get_parent().get_node("Steering"), "_on_BehaviorState_change_steering")
    if "ATTACK_STATE" in current_state:
      current_state.disconnect("entity_attack", get_parent(), "_on_AttackState_entity_attack")
    if "LOOKOUT_STATE" in current_state:
      current_state.disconnect("entity_rotate", get_parent(), "_on_LookOutState_entity_rotate")
  
  current_state = new_state
  
  current_state.connect("change_state", self, "_on_BehaviorState_change_state")
  current_state.connect("change_entity", get_parent(), "_on_BehaviorState_change_entity")
  current_state.connect("change_steering", get_parent().get_node("Steering"), "_on_BehaviorState_change_steering")
  if "ATTACK_STATE" in current_state:
    current_state.connect("entity_attack", get_parent(), "_on_AttackState_entity_attack")
  if "LOOKOUT_STATE" in current_state:
    current_state.connect("entity_rotate", get_parent(), "_on_LookOutState_entity_rotate")
  current_state._enter(get_parent())
