class_name Behavior_Ally extends Node

onready var WanderState = preload("res://allies/behavior_allies/states/WanderState.gd")

var current_state

func _ready():
  current_state = WanderState.new()
  current_state._enter(get_parent())
  
func update(delta):
  current_state._execute(get_parent(), delta)

func change_state(new_state: BaseState_Ally):
  current_state._exit(get_parent())
  
  current_state = new_state
  
  current_state._enter(get_parent())
