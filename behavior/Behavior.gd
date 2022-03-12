class_name Behavior extends Node

onready var WanderState = preload("res://behavior/states/WanderState.gd")

var current_state: BaseState

func _ready():
  current_state = WanderState.new()
  current_state._enter(get_parent())
  
func update(delta):
  current_state._execute(get_parent(), delta)

func change_state(new_state: BaseState):
  current_state._exit(get_parent())
  
  current_state = new_state
  
  current_state._enter(get_parent())
