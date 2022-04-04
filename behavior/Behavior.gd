class_name Behavior extends Node

var current_state: BaseState

func _ready():
  pass
  
func update(delta):
  if current_state != null:
    current_state._execute(get_parent(), delta)

func _on_BehaviorState_change_state(new_state: BaseState) -> void:
  if new_state == null:
    return
    
  if current_state != null:
    current_state._exit(get_parent())
    #warning-ignore-all:return_value_discarded
    current_state.disconnect("change_state", self, "_on_BehaviorState_change_state")
    current_state.disconnect("change_entity", get_parent(), "_on_BehaviorState_change_entity")
    current_state.disconnect("change_steering", get_parent().get_node("Steering"), "_on_BehaviorState_change_steering")
  
  current_state = new_state
  
  current_state.connect("change_state", self, "_on_BehaviorState_change_state")
  current_state.connect("change_entity", get_parent(), "_on_BehaviorState_change_entity")
  current_state.connect("change_steering", get_parent().get_node("Steering"), "_on_BehaviorState_change_steering")
  current_state._enter(get_parent())
